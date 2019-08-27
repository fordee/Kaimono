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
  
  var shoppingList: [ToDo] {
    return store.state.shoppingState.toDos
  }
  
  var body: some View {
    // for navigation bar title color
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
    // For navigation bar background color
    UINavigationBar.appearance().backgroundColor = UIColor(named: "back")
    
    return NavigationView {
      ShoppingListView(toDos: shoppingList)
    }.onAppear {
      self.store.dispatch(action: ShoppingActions.FetchToDos())
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

#if DEBUG

let store = Store<AppState>(reducer: appStateReducer,
                            middleware: [],
                            state: AppState())

struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    return ContentView().environmentObject(store)
  }
}
#endif
