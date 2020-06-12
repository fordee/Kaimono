//
//  FrequentItemRow.swift
//  Kaimono
//
//  Created by John Forde on 12/06/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct FrequentItemRow: View {
  
  let store: Store<FrequentItem, TodoAction>
  
  var body: some View {
    return WithViewStore(self.store) { viewStore in
      HStack {
        Text(viewStore.shoppingItem)
          .font(.custom("American Typewriter", size: 24))
          .fontWeight(.regular)
          .foregroundColor(Color("text"))
          .padding(4)
      }
      .onTapGesture {
        //viewStore.send(.checkboxTapped)
      }
    }
    
  }
}
