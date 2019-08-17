//
//  ShoppingListRow.swift
//  Kaimono
//
//  Created by John Forde on 4/07/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct ShoppingListRow : View {
  @EnvironmentObject private var store: Store<AppState>
  
  let toDo: ToDo
  
  var body: some View {
    HStack {
      if toDo.isDone {
        Image(systemName: "checkmark.circle.fill")
          .imageScale(.large)
          .foregroundColor(.secondary)
          .padding(4)
        Text(toDo.description)
          .font(.title)
          .fontWeight(.regular)
          .strikethrough()
          .foregroundColor(.secondary)
          .padding(4)
      } else {
        Image(systemName: "circle")
          .imageScale(.large)
          .foregroundColor(.primary)
          .padding(4)
        Text(toDo.description)
          .font(.title)
          .fontWeight(.regular)
          .foregroundColor(.primary)
          .padding(4)
      }
      Spacer()
    }
    .onTapGesture {
      self.store.dispatch(action: ShoppingActions.ToggleToDo(item: self.toDo))
    }
  }
}

#if DEBUG
struct ShoppingListRow_Previews : PreviewProvider {
  static var previews: some View {
    ShoppingListRow(toDo: ToDo(category: "Shopping", description: "Lettuce", done: "false", shoppingCategory: "Vegetables"))
  }
}
#endif
