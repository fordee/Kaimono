//
//  ToDoClient.swift
//  Kaimono
//
//  Created by John Forde on 13/06/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Foundation
import ComposableArchitecture
// MARK: - API client interface

struct ToDoClient {
  var getToDos: () -> Effect<[ToDo], Failure>
  var getFrequentItems: () -> Effect<[FrequentItem], Failure>
  var updateToDos: (ToDo) -> Effect<ToDo, Failure>
  var deleteToDo: (ToDo) -> Effect<String, Failure>
  var addToDo: (ToDo) -> Effect<ToDo, Failure>
  struct Failure: Error, Equatable {}
}

extension ToDoClient {
  static let live = ToDoClient(
    getToDos: {
      let url = URL(string: baseUrlString() + "/items")!
      
      return URLSession.shared.dataTaskPublisher(for: url)
        .map { data, _ in data }
        .decode(type: [ToDo].self, decoder: jsonDecoder)
        .mapError { _ in Failure() }
        .eraseToEffect()
    },
    getFrequentItems: {
      let url = URL(string: baseUrlString() + "/common-items")!
      
      return URLSession.shared.dataTaskPublisher(for: url)
        .map { data, _ in data }
        .decode(type: [FrequentItem].self, decoder: jsonDecoder)
        .mapError { _ in Failure() }
        .eraseToEffect()
    },
    updateToDos: { todo in
      let url = URL(string: baseUrlString() + "/items")!

      var request = URLRequest(url: url)
      request.httpMethod = "PUT"
      if let jsonBody = try? JSONEncoder().encode(todo) {
        request.httpBody = jsonBody
      }
      
      return URLSession.shared.dataTaskPublisher(for: request)
        .map { data, _ in data }
        .decode(type: ToDo.self, decoder: jsonDecoder)
        .mapError { resp in Failure() }
        .eraseToEffect()
    },
    deleteToDo: { todo in
      let url = URL(string: baseUrlString() + "/items/\(todo.description)/Shopping".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)!
      
      var request = URLRequest(url: url)
      request.httpMethod = "DELETE"
      
      return URLSession.shared.dataTaskPublisher(for: request)
        .map { data, _ in data }
        .decode(type: String.self, decoder: jsonDecoder)
        .mapError { _ in Failure() }
        .eraseToEffect()
    },
    addToDo: { todo in
      let url = URL(string: baseUrlString() + "/items")!

      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      if let jsonBody = try? JSONEncoder().encode(todo) {
        request.httpBody = jsonBody
      }
      
      return URLSession.shared.dataTaskPublisher(for: request)
        .map { data, _ in data }
        .decode(type: ToDo.self, decoder: jsonDecoder)
        .mapError { resp in Failure() }
        .eraseToEffect()
  })
}

// MARK: - Mock API implementations
extension ToDoClient {
  static func mock(
    getToDos: @escaping () -> Effect<[ToDo], Failure> = { fatalError("Unmocked") },
    getFrequentItems: @escaping () -> Effect<[FrequentItem], Failure> = { fatalError("Unmocked") },
    updateToDos: @escaping (ToDo) -> Effect<ToDo, Failure> = { _ in fatalError("Unmocked") },
    addToDo: @escaping (ToDo) -> Effect<ToDo, Failure> = { toDo in  fatalError("Unmocked \(toDo)") },
    deleteToDo: @escaping (ToDo) -> Effect<String, Failure> = { _ in fatalError("Unmocked") }
  ) -> Self {
    Self(
      getToDos: getToDos,
      getFrequentItems: getFrequentItems,
      updateToDos: updateToDos,
      deleteToDo: deleteToDo,
      addToDo: addToDo
    )
  }
}


// MARK: - Private helpers

private func baseUrlString() -> String {
  guard
    let path = Bundle.main.path(forResource: "Api", ofType: "plist"),
    let values = NSDictionary(contentsOfFile: path) as? [String: Any],
    let baseUrl = values["API Endpoint"] as? String
    else {
      fatalError("Api.plist file is missing 'API Endpoint' entry!")
  }
  return baseUrl
}

private let jsonDecoder: JSONDecoder = {
  let d = JSONDecoder()
//  let formatter = DateFormatter()
//  formatter.dateFormat = "yyyy-MM-dd"
//  formatter.calendar = Calendar(identifier: .iso8601)
//  formatter.timeZone = TimeZone(secondsFromGMT: 0)
//  formatter.locale = Locale(identifier: "en_US_POSIX")
//  d.dateDecodingStrategy = .formatted(formatter)
  return d
}()
