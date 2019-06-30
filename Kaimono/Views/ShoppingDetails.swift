//
//  ShoppingDetails.swift
//  Kaimono
//
//  Created by John Forde on 29/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//
// This view isn't used, but included to show how to use sharedStore

import SwiftUI
import TinyNetworking
import Model

struct ShoppingDetails : View {
  @State var toDo: ToDo = ToDo(category: "Shopping", description: "", done: "false", shoppingCategory: "None")
  @ObjectBinding var store = sharedStore
  @Environment(\.isPresented) private var isPresented
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField($toDo.description, placeholder: Text("Shopping Item"))
        }
        Section {
          Button(action: { print("Add Item"); self.dismiss()}) {
            Text("Add")
          }
          Button(action: { print("Cancel"); self.dismiss()}) {
            Text("Cancel")
          }
        }
      }
      .navigationBarTitle(Text("Add Shopping Item"), displayMode: .inline)
      .font(.headline)
    }
  }
  
  func dismiss() {
    UIApplication.shared.keyWindow?.endEditing(true)
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

