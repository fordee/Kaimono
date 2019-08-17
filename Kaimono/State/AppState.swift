//
//  AppState.swift
//  Kaimono
//
//  Created by John Forde on 17/08/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct AppState: FluxState {
  
  var shoppingState: ShoppingState
  
  init() {
    self.shoppingState = ShoppingState()
  }
  
}

