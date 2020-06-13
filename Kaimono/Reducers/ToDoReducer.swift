//
//  ToDoReducer.swift
//  Kaimono
//
//  Created by John Forde on 13/06/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Foundation
import ComposableArchitecture

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

