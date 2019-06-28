//
//  ContentView.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI
import TinyNetworking


struct ContentView : View {
  @ObjectBinding var store = sharedStore
  
  var body: some View {
    Group {
      if !store.loaded {
        Text("Loading...")
      } else {
        NavigationView {
          ShoppingListView(toDos: store.shoppingList)
        }
      }
    }
  }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    return ContentView()
  }
}
#endif
