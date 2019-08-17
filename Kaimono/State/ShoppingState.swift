//
//  ShoppingState.swift
//  Kaimono
//
//  Created by John Forde on 17/08/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct ShoppingState: FluxState, Codable {
  var toDos: [ToDo] = []
  var frequentItems: [FrequentItem] = []

  enum CodingKeys: String, CodingKey {
    case toDos
    case frequentItems
  }
}
