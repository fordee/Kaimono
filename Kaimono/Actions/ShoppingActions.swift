//
//  ShoppingActions.swift
//  Kaimono
//
//  Created by John Forde on 17/08/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct ShoppingActions {
  
  // MARK: - Requests
  
  struct FetchToDos: AsyncAction {
    
    func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
      APIService.shared.Request(endpoint: .toDos, params: nil)
      {
        (result: Result<[ToDo], APIService.APIError>) in
        switch result {
        case let .success(response):
          //let shopping = response.filter { $0.category == "Shopping" }
          dispatch(SetToDo(response: response.filter { $0.category == "Shopping" }))
        case .failure(_):
          break
        }
      }
    }
  }
  
  struct FetchFrequentItems: AsyncAction {
    
    func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
      APIService.shared.Request(endpoint: .frequentItems, params: nil, body: nil)
      {
        (result: Result<[FrequentItem], APIService.APIError>) in
        switch result {
        case let .success(response):
          dispatch(SetFrequentItems(response: response.sorted()))
        case .failure(_):
          break
        }
      }
    }
  }
  
  struct ToggleToDo: AsyncAction {
    let item: ToDo
    
    func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
      let done = item.isDone ? "false" : "true"
      let toDo = ToDo(category: item.category, description: item.description, done: done, shoppingCategory: item.shoppingCategory)
      let body = try! JSONEncoder().encode(toDo)
      
      APIService.shared.Request(method: .put, endpoint: .toDos, params: nil, body: body)
      {
        (result: Result<String, APIService.APIError>) in
        switch result {
        case let .success(response):
          dispatch(SetToggleToDo(todo: toDo))
          print(response)
          break
        case .failure(_):
          break
        }
      }
    }
  }
  
  struct AddToDo: AsyncAction {
    let item: ToDo
    
    func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
      let body = try! JSONEncoder().encode(item)
      
      APIService.shared.Request(method: .post, endpoint: .toDos, params: nil, body: body) {
        (result: Result<String, APIService.APIError>) in
        switch result {
        case let .success(response):
          dispatch(SetAddToDo(response: self.item))
          print(response)
          break
        case .failure(_):
          break
        }
        
      }
    }
  }
  
  struct DeleteToDo: AsyncAction {
    let item: ToDo
    
    func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
      APIService.shared.Request(method: .delete, endpoint: .deleteToDo(item), params: nil, body: nil) {
        (result: Result<String, APIService.APIError>) in
        switch result {
        case let .success(response):
          dispatch(SetDeleteToDo(response: self.item))
          print(response)
        case .failure(_):
          break
        }
      }
    }
  }
  
  struct SetToDo: Action {
    let response: [ToDo]
  }
  
  struct SetFrequentItems: Action {
    let response: [FrequentItem]
  }
  
  struct SetToggleToDo: Action {
    let todo: ToDo
  }
  
  struct SetAddToDo: Action {
    let response: ToDo
  }
  
  struct SetDeleteToDo: Action {
    let response: ToDo
  }

}

