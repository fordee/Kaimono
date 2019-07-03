//
//  ShoppingDetails.swift
//  Kaimono
//
//  Created by John Forde on 29/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//
// This view isn't used, but included to show how to use sharedStore

import SwiftUI

struct ShoppingDetails : View {
  @State var toDo: ToDo = ToDo(category: "Shopping", description: "", done: "false", shoppingCategory: "None")
  @ObjectBinding var store = sharedStore
  @Environment(\.isPresented) private var isPresented
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Shopping Item", text: $toDo.description)
        }
      }
      .navigationBarTitle(Text("Add Shopping Item"), displayMode: .inline)
      .navigationBarItems(leading:
        Button(action: {
          print("Cancel")
          self.dismiss()
        }) {
          Text("Cancel")
        },
        trailing: Button(action: {
          print("Add")
          self.store.saveToDo(toDo: self.toDo)
          self.dismiss()
        }) {
          Image(systemName: "plus")
        })
    }
  }
  
  func dismiss() {
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

