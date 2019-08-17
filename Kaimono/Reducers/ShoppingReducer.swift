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
    state.toDos.append(action.response)
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
    
    //movies[action.id] = action.movie
    //        state.recommended[action.movie] = action.response.results.map{ $0.id }
    //        state = mergeMovies(movies: action.response.results, state: state)
    //    case let action as MoviesActions.AddToWishlist:
    //        state.wishlist.insert(action.movie)
    //
    //        var meta = state.moviesUserMeta[action.movie] ?? MovieUserMeta()
    //        meta.dateAddedToWishlist = Date()
    //        state.moviesUserMeta[action.movie] = meta
    //
    //    case let action as MoviesActions.RemoveFromWishlist:
    //        state.wishlist.remove(action.movie)
    //        state.moviesUserMeta[action.movie]?.dateAddedToWishlist = nil
  
  default:
    break
  }
  
  
  return state
}

