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
  let toDo: ToDo
  @ObjectBinding var store = sharedStore
  
  init(toDo: ToDo) {
    self.toDo = toDo
  }
  var body: some View {
    VStack {
      Text(toDo.description).font(.largeTitle).lineLimit(nil)
      Text(toDo.shoppingCategory).lineLimit(nil)
    }
  }
}

#if DEBUG
struct ShoppingDetails_Previews : PreviewProvider {
  static var previews: some View {
    ShoppingDetails(toDo: ToDo(category: "Shopping", description: "Lettuce", done: "done", shoppingCategory: "Vegetables"))
  }
}
#endif

