//
//  KaimonoTests.swift
//  KaimonoTests
//
//  Created by John Forde on 14/06/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Combine
import ComposableArchitecture
import XCTest

@testable import Kaimono

class KaimonoTests: XCTestCase {
  
  let scheduler = DispatchQueue.testScheduler
  
  func testGetAllToDos() throws {
    let store = TestStore(
      initialState: .init(),
      reducer: appReducer,
      environment: AppEnvironment(
        toDoClient: .mock(),
        mainQueue: self.scheduler.eraseToAnyScheduler()
      )
    )
    
    store.assert(
      .environment {
        $0.toDoClient.getToDos = { Effect(value: self.mockToDos)}
      },
      .send(.fetchAll) {
        $0.toDos = []
      },
      .do { self.scheduler.advance(by: 0.3) },
      .receive(.getToDosResponse(.success(mockToDos))) {
        $0.toDos = self.mockToDos
      }
    )
  }
  
  func testGetAllToDosFailure() throws {
    let store = TestStore(
      initialState: .init(),
      reducer: appReducer,
      environment: AppEnvironment(
        toDoClient: .mock(),
        mainQueue: self.scheduler.eraseToAnyScheduler()
      )
    )
    
    store.assert(
      .environment {
        $0.toDoClient.getToDos = { Effect(error: .init())}
      },
      .send(.fetchAll) {
        $0.toDos = []
      },
      .do { self.scheduler.advance(by: 0.3) },
      .receive(.getToDosResponse(.failure(.init())))
    )
  }
  
  private var mockToDos: [ToDo] = [
    ToDo(category: "Shopping", description: "eggs", done: "false", shoppingCategory: "Dairy"),
    ToDo(category: "Shopping", description: "bacon", done: "false", shoppingCategory: "Meat"),
    ToDo(category: "Shopping", description: "milk", done: "true", shoppingCategory: "Dairy"),
    ToDo(category: "Shopping", description: "lamb", done: "true", shoppingCategory: "Meat"),
  ]
  
}
