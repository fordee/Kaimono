//
//  ShoppingDetails.swift
//  Kaimono
//
//  Created by John Forde on 29/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct ShoppingDetails : View {
  @EnvironmentObject private var store: Store<AppState>
  
  @State private var toDo: ToDo = ToDo(category: "Shopping", description: "", done: "false", shoppingCategory: "None")
  @Environment(\.presentationMode) var presentationMode
  
  
  //@ObservedObject var frequentItemStore = FrequentItemsStore()
  
  var frequentItemsList: [FrequentItem] {
    return store.state.shoppingState.frequentItems//.moviesState.movies[movieId]
  }

  var body: some View {
    NavigationView {
      VStack { // Can't use a List in a Form
        TextField("Shopping Item", text: $toDo.description)
          .font(.title)
          .padding()
        
        List {
          ForEach (frequentItemsList/*frequentItemStore.frequentItemsList*/) { item in
            self.FrequentItemsRow(item)
          }
        }
      }.onAppear {
        self.store.dispatch(action: ShoppingActions.FetchFrequentItems())
      }
      .navigationBarTitle(Text("Add Shopping Item"), displayMode: .inline)
      .navigationBarItems(
          leading:
          Button(action: {
            print("Done")
            //sharedToDoStore.reload()
            self.dismiss()
          }) {
            Text("Done")
          },
          trailing: Button(action: {
            print("Add")
            //sharedToDoStore.saveToDo(toDo: self.toDo)
            self.store.dispatch(action: ShoppingActions.AddToDo(item: self.toDo))
          }) {
            Image(systemName: "plus")
            .imageScale(.large)
        })
    }
  }
  
  
  private func FrequentItemsRow(_ item: FrequentItem) -> some View {
    Text(item.shoppingItem)
      .font(.title)
      .fontWeight(.regular)
      .onTapGesture {
        print("tapped \(item.shoppingItem)")
        self.toDo = ToDo(category: "Shopping", description: item.shoppingItem, done: "false", shoppingCategory: item.category ?? "No Category")
    }
  }
  
  private func dismiss() {
    presentationMode.value.dismiss()
  }
}

#if DEBUG
struct ShoppingDetails_Previews : PreviewProvider {
  static var previews: some View {
    ShoppingDetails()
  }
}
#endif

