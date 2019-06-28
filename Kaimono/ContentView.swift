//
//  ContentView.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI

struct ContentView : View {
  @EnvironmentObject var shoppingList: ShoppingList
  
  var body: some View {
    NavigationView {
      List(self.shoppingList.items) { item in
        ShoppingListRow(itemName: item.description, bought: item.isDone)
      }
      .navigationBarTitle(Text("Shopping List"))
      .navigationBarItems(trailing:
        Button(action: {
          print("Refresh tapped!")
          self.shoppingList.load()
        }) {
          Image(systemName: "arrow.clockwise")
      })
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
