//
//  FrequentItem.swift
//  Kaimono
//
//  Created by John Forde on 3/07/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import SwiftUI

public struct FrequentItem: Codable, Equatable, Hashable {
  
  public static func == (lhs: FrequentItem, rhs: FrequentItem) -> Bool {
    return lhs.frequencyInt! > rhs.frequencyInt!
  }
  
  var shoppingItem: String
  var frequency: String
  var category: String
  
  var frequencyInt: Int? {
    return Int(frequency)
  }
  
  public init() {
    self.shoppingItem = ""
    self.frequency = ""
    self.category = ""
  }
  
  public init(shoppingItem: String, frequency: String, category: String) {
    self.shoppingItem = shoppingItem
    self.frequency = frequency
    self.category = category
  }
  
  public init(shoppingItem: String) {
    self.shoppingItem = shoppingItem
    frequency = ""
    category = ""
  }
}

extension FrequentItem: Comparable {
  public static func < (lhs: FrequentItem, rhs: FrequentItem) -> Bool {
    guard let lhsFrequency = Int(lhs.frequency) else { return false }
    guard let rhsFrequency = Int(rhs.frequency) else { return false }
    return lhsFrequency < rhsFrequency
  }
}

