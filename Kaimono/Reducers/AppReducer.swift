//
//  AppReducer.swift
//  Kaimono
//
//  Created by John Forde on 17/08/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import Foundation
import SwiftUIFlux

func appStateReducer(state: AppState, action: Action) -> AppState {
    var state = state
    state.shoppingState = shoppingStateReducer(state: state.shoppingState, action: action)
    return state
}

