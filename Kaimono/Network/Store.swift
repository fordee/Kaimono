//
//  ShoppingList.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

func apiEndpointString() -> String {
  guard
    let path = Bundle.main.path(forResource: "Api", ofType: "plist"),
    let values = NSDictionary(contentsOfFile: path) as? [String: Any],
    let apiEndpoint = values["API Endpoint"] as? String
    else {
      fatalError("Api.plist file is missing 'API Endpoint' entry!")
  }
  return apiEndpoint
}

let allToDos =  Endpoint<[ToDo]>(json: .get, url: URL(string: apiEndpointString() + "/items")!)
let allFrequentItems =  Endpoint<[FrequentItem]>(json: .get, url: URL(string: apiEndpointString() + "/common-items")!)

let sharedToDoStore = ToDoStore()
let sharedFrequentItemsStore = FrequentItemsStore()

final class FrequentItemsStore: ObservableObject {
  let objectWillChange: AnyPublisher<[FrequentItem]?, Never>
  let sharedFrequentItems = Resource(endpoint: allFrequentItems)
  
  init() {
    objectWillChange = sharedFrequentItems.objectWillChange.eraseToAnyPublisher()
  }
  
  var frequentItems: [FrequentItem] { sharedFrequentItems.value ?? [] }
  
  var frequentItemsList: [FrequentItem] {
    frequentItems.sorted().forEach { print("Category: \($0.category ?? "")") }
    return Array(frequentItems.sorted().prefix(50))
  }
  
  func reload() {
    sharedFrequentItems.reload()
  }
}


final class ToDoStore: ObservableObject {
  let objectWillChange: AnyPublisher<[ToDo]?, Never>
  let sharedToDos = Resource(endpoint: allToDos)
  
  init() {
    objectWillChange = sharedToDos.objectWillChange.eraseToAnyPublisher()
  }
  
  var loaded: Bool {
    sharedToDos.value != nil
  }
  
  var toDos: [ToDo] { sharedToDos.value ?? [] }
  
  var shoppingList: [ToDo] {
    toDos.filter { $0.category == "Shopping" }
  }
  
  func reload() {
    sharedToDos.reload()
  }
  
  func deleteToDos(toDos: [ToDo]) {
    for toDo in toDos {
      deleteToDo(toDo: toDo)
    }
  }
  
  func deleteToDo(toDo: ToDo) {
    let deleteString = "/items/\(toDo.description)/Shopping".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
    let deleteEndpoint = Endpoint<ToDo>(json: .delete, url: URL(string: apiEndpointString() + deleteString)!)
    URLSession.shared.load(deleteEndpoint) {
      print($0)
      self.reload() // TODO: Do we want to refresh every time? Probably not.
    }
  }
  
  func saveToDo(toDo: ToDo) {
    let saveToDoEndpoint = Endpoint<ToDo>(json: .post, url: URL(string: apiEndpointString() + "/items")!, body: toDo)
    URLSession.shared.load(saveToDoEndpoint) {
      print($0)
    }
  }
  
  func toggleToDo(toDo: ToDo) {
    let done = toDo.isDone ? "false" : "true"
    let item = ToDo(category: toDo.category, description: toDo.description, done: done, shoppingCategory: toDo.shoppingCategory)
    let toggleToDo = Endpoint<ToDo>(json: .post, url: URL(string: apiEndpointString() + "/items")!, body: item)
    URLSession.shared.load(toggleToDo) {
      print($0)
      self.reload()
    }
  }
}
