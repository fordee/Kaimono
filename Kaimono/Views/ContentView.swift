//
//  ContentView.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI

struct ContentView : View {
  @ObservedObject var store = sharedToDoStore
  
  var body: some View {
    Group {
      if !store.loaded {
        Text("Loading...")
          .font(.title)
          .fontWeight(.regular)
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
