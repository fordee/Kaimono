//
//  ToDo.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import SwiftUI

// This is the bare Photo model.
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
  
  mutating func toggleDone() {
    if isDone {
      done = "false"
    } else {
      done = "true"
    }
  }
}

extension Identifiable where Self: Hashable {
  public var id: Int { return hashValue }
}
