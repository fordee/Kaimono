//
//  ShoppingListRow.swift
//  Kaimono
//
//  Created by John Forde on 4/07/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI

struct ShoppingListRow : View {
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
          .fontWeight(.semibold)
          .strikethrough()
          .color(.secondary)
          .padding(4)
      } else {
        Image(systemName: "circle")
          .imageScale(.large)
          .foregroundColor(.accentColor)
          .padding(4)
        Text(toDo.description)
          .font(.title)
          .fontWeight(.semibold)
          .color(.accentColor)
          .padding(4)
      }
      Spacer()
    }
    .tapAction {
      print("Tapped \(self.toDo.description)!")
      sharedStore.toggleToDo(toDo: self.toDo)
    }
  }
}

#if DEBUG
struct ShoppingListRow_Previews : PreviewProvider {
  static var previews: some View {
    ShoppingListRow(toDo: ToDo(category: "Shopping", description: "Lettuce", done: "true", shoppingCategory: "Vegetables"))
  }
}
#endif
