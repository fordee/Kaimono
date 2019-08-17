//
//  ShoppingReducer.swift
//  Kaimono
//
//  Created by John Forde on 17/08/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import SwiftUIFlux

func shoppingStateReducer(state: ShoppingState, action: Action) -> ShoppingState {
  var state = state
  switch action {
    
  case let action as ShoppingActions.SetAddToDo:
    if !state.toDos.contains(action.response) {
      state.toDos.append(action.response)
    }
  case let action as ShoppingActions.SetToDo:
    state.toDos = action.response
    
  case let action as ShoppingActions.SetFrequentItems:
    state.frequentItems = action.response
    
  case let action as ShoppingActions.SetDeleteToDo:
    if let index = state.toDos.firstIndex(of: action.response) {
        state.toDos.remove(at: index)
    }
    
  case let action as ShoppingActions.SetToggleToDo:
    for (index, item) in state.toDos.enumerated() {
      if action.todo.description == item.description {
        state.toDos[index].done = action.todo.done
      }
    }
  
  default:
    break
  }
  
  
  return state
}

