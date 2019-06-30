//
//  ToDo.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import SwiftUI

struct ToDo: Codable, Hashable, Identifiable {
  
  enum CodingKeys: String, CodingKey {
    case category = "category"
    case description = "description"
    case done = "done"
    case shoppingCategory = "shoppingCategory"
  }
  var category = ""
  var description = ""
  var done = ""
  var shoppingCategory = ""
  var isDone: Bool {
    return done == "true"
  }
  
  public init(category: String, description: String, done: String, shoppingCategory: String) {
    self.category = category
    self.description = description
    self.done = done
    self.shoppingCategory = shoppingCategory
  }
}

extension Identifiable where Self: Hashable {
  public var id: Int { return hashValue }
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
