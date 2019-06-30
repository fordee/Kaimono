//
//  ShoppingListView.swift
//  Kaimono
//
//  Created by John Forde on 29/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI
import Model
import ViewHelpers

struct ShoppingListView : View {
  let toDos: [ToDo]
  var body: some View {
    List(toDos.sorted()) { toDo in
      HStack {
        if toDo.isDone {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.secondary)
          Text(toDo.description)
            .font(.headline)
            .fontWeight(.semibold)
            .strikethrough()
            .color(.secondary)
            .padding(4)
        } else {
          Image(systemName: "circle")
            .foregroundColor(.accentColor)
          Text(toDo.description)
            .font(.headline)
            .fontWeight(.semibold)
            .color(.accentColor)
            .padding(4)
        }
      }.tapAction {
        print("Tapped \(toDo.description)!")
        sharedStore.toggleToDo(toDo: toDo)
      }
    }
    .navigationBarTitle(Text("Shopping List"))
    .navigationBarItems(leading:
      Button(action: {
        print("Refresh tapped!")
        sharedStore.reload()
      }) {
        Image(systemName: "arrow.clockwise")
      },
      trailing: PresentationButton(destination: ShoppingDetails()) {
        Image(systemName: "plus")
    })
  }
}

#if DEBUG
struct ShoppingListView_Previews : PreviewProvider {
  static var previews: some View {
    NavigationView {
      ShoppingListView(toDos: [ToDo(category: "Shopping", description: "Lettuce", done: "done", shoppingCategory: "Vegetables")])
    }
  }
}
#endif
