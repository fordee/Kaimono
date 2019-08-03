//
//  ShoppingListView.swift
//  Kaimono
//
//  Created by John Forde on 29/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI

struct ShoppingListView : View {
  
  @State var showingShoppingDetails = false
  
  var detailsButton: some View {
    Button(action: { self.showingShoppingDetails.toggle() }) {
      Image(systemName: "plus")
        .imageScale(.large)
        .padding()
    }
  }
  
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
            sharedToDoStore.reload()
          }) {
            Image(systemName: "arrow.clockwise")
              .imageScale(.large)
          }.padding()
          Button(action: {
            print("Delete")
            sharedToDoStore.deleteToDos(toDos: self.toDos.filter { $0.done == "true"} )
          }, label: {
            Image(systemName: "trash")
              .imageScale(.large)
          }).padding()
        },
        trailing: detailsButton)
      .sheet(isPresented: $showingShoppingDetails, onDismiss: {
        sharedToDoStore.reload()
      }, content:  {
        ShoppingDetails()
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
