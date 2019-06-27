//
//  ContentView.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI

struct ContentView : View {
  var body: some View {
    NavigationView {
      List() {
        ShoppingListRow(itemName: "Test", bought: true)
        ShoppingListRow(itemName: "Test", bought: false)
      }
      .navigationBarTitle(Text("Shopping List"))
    }
  }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
