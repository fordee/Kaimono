//
//  AppReducer.swift
//  Kaimono
//
//  Created by John Forde on 13/06/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Foundation
import ComposableArchitecture

enum AppAction: Equatable {
  case getToDosResponse(Result<[ToDo], ToDoClient.Failure>)
  case frequentItem(index: Int, text: String)
  case toDo(index: Int, action: TodoAction)
  //case addButtonTapped
  case deleteButtonTapped
  case deleteButtonTappedResponse(Result<String, ToDoClient.Failure>)
  case addToDoResponse(Result<ToDo, ToDoClient.Failure>)
  case fetchAll
  case getFrequentItems
  case getFrequentItemsResponse(Result<[FrequentItem], ToDoClient.Failure>)
  
  case editText(String)
  case addItem
  
  case setSheet(isPresented: Bool)
  case setSheetIsPresentedDelayCompleted
}

struct AppEnvironment {
  var toDoClient: ToDoClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - ToDo feature reducer
let appReducer =
  Reducer<AppState, AppAction, AppEnvironment>
  .combine(
  toDoReducer.forEach(state: \AppState.toDos,
                        action: /AppAction.toDo(index:action:),
                        environment: { environment in TodoEnvironment(toDoClient: environment.toDoClient, mainQueue: environment.mainQueue) }),
  Reducer /*<AppState, AppAction, AppEnvironment>*/ {
    state, action, environment in
    switch action {
    case .getToDosResponse(.failure):
      state.toDos = []
      return .none
      
    case let .getToDosResponse(.success(response)):
      state.toDos = response.filter { $0.category == "Shopping" }
      return .none
      
    case .addToDoResponse(.failure):
      return .none
      
    case let .addToDoResponse(.success(response)):
      return .none
      
    case .deleteButtonTapped:
      struct ToDoId: Hashable {}
      if let toDo = state.toDos.first(where: { $0.isDone } ) {
        return environment.toDoClient
          .deleteToDo(toDo)
          .receive(on: environment.mainQueue)
          .catchToEffect()
          .map(AppAction.deleteButtonTappedResponse)
          .cancellable(id: ToDoId(), cancelInFlight: true)
      } else {
        return .none
      }
      
    case let .deleteButtonTappedResponse(.success(response)):
      struct ToDoId: Hashable {}
      if let toDo = state.toDos.first(where: { $0.isDone } ) {
        if let index = state.toDos.firstIndex(of: toDo) {
          state.toDos.remove(at: index)
        }
        return environment.toDoClient
          .deleteToDo(toDo)
          .receive(on: environment.mainQueue)
          .catchToEffect()
          .map(AppAction.deleteButtonTappedResponse)
          .cancellable(id: ToDoId(), cancelInFlight: true)
      } else {
        return .none
      }
      
    case .deleteButtonTappedResponse(.failure):
      return .none
      
    case .fetchAll:
      struct ToDoId: Hashable {}
      return environment.toDoClient
        .getToDos()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(AppAction.getToDosResponse)
        .cancellable(id: ToDoId(), cancelInFlight: true)
    
    case .getFrequentItems:
      struct FrequentId: Hashable {}
      return environment.toDoClient
        .getFrequentItems()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(AppAction.getFrequentItemsResponse)
        .cancellable(id: FrequentId(), cancelInFlight: true)
    
    case .getFrequentItemsResponse(.failure):
      state.frequentItems = []
      return .none
      
    case let .getFrequentItemsResponse(.success(response)):
      state.frequentItems = response.sorted()
      return .none
    
    case .toDo(index: _, action: .checkboxTapped):
      return .none
      
    case .toDo(index: let index, action: let action):
      return .none
      
    case .setSheet(isPresented: let isPresented):
      return .none
      
    case .setSheetIsPresentedDelayCompleted:
      return .none
      
    case .editText(let text):
      state.shoppingItem = text
      return .none
      
    case .frequentItem(index: let index, text: let text):
      print("Tapped: \(text) at \(index)")
      state.shoppingItem = text
      return .none
      
    case .addItem:
      let toDo = ToDo(category: "Shopping", description: state.shoppingItem, done: "false", shoppingCategory: "No Category")
      state.toDos.append(toDo)
      state.shoppingItem = ""
      struct ToDoId: Hashable {}
      return environment.toDoClient
        .addToDo(toDo)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(AppAction.addToDoResponse)
        .cancellable(id: ToDoId(), cancelInFlight: true)
    }
})
