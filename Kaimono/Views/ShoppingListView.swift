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
      ShoppingListRow(toDo: toDo)
    }
    .navigationBarTitle(Text("Shopping List"))
    .navigationBarItems(leading:
      HStack {
      Button(action: {
        print("Refresh tapped!")
        sharedStore.reload()
      }) {
        Image(systemName: "arrow.clockwise")
        .imageScale(.large)
      }.padding()
      Button(action: {
        print("Delete")
        self.store.deleteToDos(toDos: self.toDos.filter { $0.done == "true"} )
      }, label: {
        Image(systemName: "trash")
        .imageScale(.large)
      }).padding()
      },
        trailing: PresentationLink(destination: ShoppingDetails()) {
        Image(systemName: "plus")
        .imageScale(.large)
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
