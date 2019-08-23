//
//  ShoppingDetails.swift
//  Kaimono
//
//  Created by John Forde on 29/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct AddShoppingItem : View {
  @EnvironmentObject private var store: Store<AppState>
  @Environment(\.presentationMode) var presentationMode
  @State private var toDo: ToDo = ToDo(category: "Shopping", description: "", done: "false", shoppingCategory: "None")

  var frequentItemsList: [FrequentItem] {
    return store.state.shoppingState.frequentItems
  }

  var body: some View {
    // for navigation bar title color
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
    // For navigation bar background color
    UINavigationBar.appearance().backgroundColor = .systemYellow
    UINavigationBar.appearance().isOpaque = true
    
    return NavigationView {
      VStack {
        TextField("Shopping Item", text: $toDo.description)
          .font(.title)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.top).padding(.leading).padding(.trailing).padding(.bottom, 4)
        
        List {
          ForEach (frequentItemsList) { item in
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
            self.dismiss()
          }) {
            Text("Done")
          },
          trailing: Button(action: {
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
    presentationMode.wrappedValue.dismiss()
  }
}

#if DEBUG
struct ShoppingDetails_Previews : PreviewProvider {
  
  static var previews: some View {
    AddShoppingItem().environmentObject(store)
  }
}
#endif

