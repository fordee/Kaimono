//
//  ToDo.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import ComposableArchitecture

// MARK: - API models

struct ToDo: Codable, Identifiable {
  var id: String {
    description + done
  }
  var category: String
  var description: String
  var done: String
  var shoppingCategory: String
  var isDone: Bool {
    return done == "true"
  }
}

extension ToDo: Equatable {
  static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
    return lhs.description == rhs.description
  }
}

extension ToDo: Comparable {
  static func < (lhs: ToDo, rhs: ToDo) -> Bool {
    switch (lhs.done, rhs.done) {
    case ("true", "true"):
      return lhs.description < rhs.description
    case ("true", "false"):
      return false
    case ("false", "true"):
      return true
    case ("false", "false"):
      return lhs.description < rhs.description
    default:
      print("Found unexpected done status: (\(lhs.done), \(rhs.done))")
      return false
    }
  }
}

extension ToDo {
  private enum CodingKeys: String, CodingKey {
    case category = "category"
    case description = "description"
    case done = "done"
    case shoppingCategory = "shoppingCategory"
  }
}
