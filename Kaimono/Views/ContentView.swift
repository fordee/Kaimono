//
//  ContentView.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct ContentView : View {
  @EnvironmentObject private var store: Store<AppState>
  
  //@ObservedObject var store = sharedToDoStore
  
  var shoppingList: [ToDo] {
    return store.state.shoppingState.toDos//.moviesState.movies[movieId]
  }
  
  var body: some View {
//    Group {
//      if !store.loaded {
//        Text("Loading...")
//          .font(.title)
//          .fontWeight(.regular)
//      } else {
        NavigationView {
          ShoppingListView(toDos: shoppingList)
        }.onAppear {
          self.store.dispatch(action: ShoppingActions.FetchToDos())
        }
//      }
//    }
  }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    return ContentView()
  }
}
#endif
