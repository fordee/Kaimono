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

class ShoppingList: BindableObject {
  public let didChange = PassthroughSubject<ShoppingList, Never>()
  
  var items: [ToDo] = [] {
    didSet {
      update()
    }
  }
  
  func load() {
    guard
      let path = Bundle.main.path(forResource: "Api", ofType: "plist"),
      let values = NSDictionary(contentsOfFile: path) as? [String: Any],
      let apiEndpoint = values["API Endpoint"] as? String
      else {
        fatalError("Api.plist file is missing 'API Endpoint' entry!")
    }
    
    let url = URL(string: apiEndpoint + "/items")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) {
      guard let data = $0 else {
        print("No data in response: \($2?.localizedDescription ?? "Unkown Error")")
        return
      }
      if let todos = try? JSONDecoder().decode([ToDo].self, from: data) {
        print("decoded: \(todos)")
        DispatchQueue.main.async {
          self.items = todos.filter { $0.category == "Shopping" }
        }
      } else {
        let dataString = String(decoding: data, as: UTF8.self)
        print("Error decoding data: \(dataString)")
      }
    }.resume()
  }
  
  func update() {
    didChange.send(self)//eraseToAnyPublisher().receive(on: RunLoop.main)
    print("Did Change: \(items)")
  }
  
}
