//
//  ContentView.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI
import ComposableArchitecture


// MARK: - ToDo feature domain
struct AppState: Equatable {
  var toDos: [ToDo] = []
  var frequentItems: [FrequentItem] = []
  var isSheetPresented = false
}

enum AppAction: Equatable {
  case getToDosResponse(Result<[ToDo], ToDoClient.Failure>)
  case toDo(index: Int, action: TodoAction)
  case addButtonTapped
  case deleteButtonTapped
  case deleteButtonTappedResponse(Result<String, ToDoClient.Failure>)
  case addToDoResponse(Result<ToDo, ToDoClient.Failure>)
  case fetchAll
  case getFrequentItems
  case getFrequentItemsResponse(Result<[FrequentItem], ToDoClient.Failure>)
  case frequentItem(index: Int, action: FrequentItemAction)
  
  case setSheet(isPresented: Bool)
  case setSheetIsPresentedDelayCompleted
}

struct AppEnvironment {
  var toDoClient: ToDoClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

enum TodoAction: Equatable {
  case checkboxTapped
  case updateToDosResponse(Result<ToDo, ToDoClient.Failure>)
  case textFieldChanged(String)
}

struct TodoEnvironment {
  var toDoClient: ToDoClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let toDoReducer = Reducer<ToDo, TodoAction, TodoEnvironment> { state , action, environment in
  switch action {
  case .checkboxTapped:
    state.done =  state.isDone ? "false" : "true"
    struct ToDoId: Hashable {}
    return environment.toDoClient
      .updateToDos(state)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(TodoAction.updateToDosResponse)
      .cancellable(id: ToDoId(), cancelInFlight: true)
    
  case .updateToDosResponse(.failure):
    // TODO: Show error message
    return .none
  case let .updateToDosResponse(.success(response)):
    return .none
  case .textFieldChanged(let text):
    state.description = text
    return .none
  }
}

enum FrequentItemAction: Equatable {
  case itemTapped
}

struct FrequentItemEnvironment {
  var toDoClient: ToDoClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let frequentItemReducer = Reducer<FrequentItem, FrequentItemAction, FrequentItemEnvironment> { state , action, environment in
  switch action {
  case .itemTapped:
    return .none
  }
}

// MARK: - ToDo feature reducer
let appReducer =
  Reducer<AppState, AppAction, AppEnvironment>
  .combine(
  frequentItemReducer.forEach(state: \AppState.frequentItems,
                        action: /AppAction.frequentItem(index:action:),
                        environment: { environment in FrequentItemEnvironment(toDoClient: environment.toDoClient, mainQueue: environment.mainQueue) }),
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
      
    case .addButtonTapped:
      struct ToDoId: Hashable {}
      let toDo = ToDo(category: "Shopping", description: "New To Do", done: "false", shoppingCategory: "No Category")
      state.toDos.append(toDo)
      return environment.toDoClient
        .addToDo(toDo)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(AppAction.addToDoResponse)
        .cancellable(id: ToDoId(), cancelInFlight: true)
      
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
      
    case .frequentItem(index: _, action: .itemTapped):
      return .none
    case .setSheet(isPresented: let isPresented):
      return .none
    case .setSheetIsPresentedDelayCompleted:
      return .none
    }
})//)

struct ContentView : View {
  let store: Store<AppState, AppAction>
  
  @State var showingAddItemView = false
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        
        List {
          ForEachStore(
            self.store.scope(state: \.toDos, action: AppAction.toDo(index:action:)),
            content: ShoppingListRow.init(store:)
          )
        }
        .navigationBarTitle("買い物")
        .navigationBarItems(
          leading: HStack(spacing: 16.0) {
            Button(action: {
              viewStore.send(.fetchAll)
            }) {
              Image(systemName: "arrow.clockwise")
                .imageScale(.large)
            }
            Button(action: {
              viewStore.send(.deleteButtonTapped)
            }) {
              Image(systemName: "trash")
                .imageScale(.large)
            }
          },
          trailing: Button(action: {
            //viewStore.send(.addButtonTapped)
            self.showingAddItemView.toggle()
          }) {
            Image(systemName: "plus")
              .imageScale(.large)
          })
          .sheet(isPresented: self.$showingAddItemView) {
            AddShoppingItemView.init(store: self.store)
          }
          .onAppear() {
            viewStore.send(.fetchAll)
        }
        .navigationViewStyle(StackNavigationViewStyle())
      }
    }
  }
}

#if DEBUG

struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        toDoClient: ToDoClient(
          getToDos: {
            Effect(value: [
              ToDo(category: "shopping", description: "Eggs", done: "false", shoppingCategory: "Dairy"),
              ToDo(category: "shopping", description: "Milk", done: "false", shoppingCategory: "Dairy"),
              ToDo(category: "shopping", description: "Lamb", done: "false", shoppingCategory: "Meat"),
            ])
        }, getFrequentItems: {
          Effect(value: [FrequentItem(shoppingItem: "Beer")])
        }
          , updateToDos: { _ in
          Effect(value: ToDo(category: "shopping", description: "Eggs", done: "true", shoppingCategory: "Dairy"))
        }, deleteToDo: { _ in
          Effect(value: "Eggs deleted")
        },
           addToDo: { _ in
            Effect(value: ToDo(category: "shopping", description: "Beef", done: "false", shoppingCategory: "Dairy"))
        }),
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )
    return ContentView(store: store)
  }
}
#endif
