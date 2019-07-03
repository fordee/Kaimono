//
//  ShoppingListView.swift
//  Kaimono
//
//  Created by John Forde on 29/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI

struct ShoppingListView : View {
  @ObjectBinding var store = sharedStore
  
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
      HStack {
      Button(action: {
        print("Refresh tapped!")
        sharedStore.reload()
      }) {
        Image(systemName: "arrow.clockwise")
      }.padding()
      Button(action: {
        print("Delete")
        self.store.deleteToDos(toDos: self.toDos.filter { $0.done == "true"} )
      }, label: {
        Image(systemName: "trash")
      }).padding()
      },
        trailing: PresentationLink(destination: ShoppingDetails()) {
        Image(systemName: "plus")
    })
  }
}

#if DEBUG
struct ShoppingListView_Previews : PreviewProvider {
  static var previews: some View {
    NavigationView {
      ShoppingListView(toDos: [ToDo(category: "Shopping", description: "Lettuce", done: "true", shoppingCategory: "Vegetables"),
      ToDo(category: "Shopping", description: "Pototoes", done: "false", shoppingCategory: "Vegetables")])
    }
  }
}
#endif
