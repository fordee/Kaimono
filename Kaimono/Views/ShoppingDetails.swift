//
//  ShoppingDetails.swift
//  Kaimono
//
//  Created by John Forde on 29/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI

struct ShoppingDetails : View {
  @State private var toDo: ToDo = ToDo(category: "Shopping", description: "", done: "false", shoppingCategory: "None")
  @Environment(\.isPresented) private var isPresented
  
  @ObjectBinding var frequentItemStore = FrequentItemsStore()

  var body: some View {
    NavigationView {
      VStack { // Can't use a List in a Form
        TextField("Shopping Item", text: $toDo.description)
          .font(.title)
          .padding()
        
        List (frequentItemStore.frequentItemsList) { item in
          self.FrequentItemsRow(item)
        }
      }
      .navigationBarTitle(Text("Add Shopping Item"), displayMode: .inline)
        .navigationBarItems(leading:
          Button(action: {
            print("Done")
            sharedToDoStore.reload()
            self.dismiss()
          }) {
            Text("Done")
          },
          trailing: Button(action: {
            print("Add")
            sharedToDoStore.saveToDo(toDo: self.toDo)
            //self.dismiss()
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
      .tapAction {
        print("tapped \(item.shoppingItem)")
        self.toDo = ToDo(category: "Shopping", description: item.shoppingItem, done: "false", shoppingCategory: item.category ?? "No Category")
    }
  }
  
  private func dismiss() {
    isPresented?.value = false
  }
}

#if DEBUG
struct ShoppingDetails_Previews : PreviewProvider {
  static var previews: some View {
    ShoppingDetails()
  }
}
#endif

