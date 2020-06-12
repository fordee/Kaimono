//
//  ShoppingListRow.swift
//  Kaimono
//
//  Created by John Forde on 4/07/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ShoppingListRow : View {
  
  let store: Store<ToDo, TodoAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack {
        if viewStore.isDone {
          Image(systemName: "checkmark.circle.fill")
            .imageScale(.large)
            .foregroundColor(.secondary)
            .padding(4)
          Text(viewStore.description)
            .font(.custom("American Typewriter", size: 24))
            .fontWeight(.regular)
            .strikethrough()
            .foregroundColor(.secondary)
            .padding(4)
        } else {
          Image(systemName: "circle")
            .imageScale(.large)
            .foregroundColor(Color("text"))
            .padding(4)
          Text(viewStore.description)
            .font(.custom("American Typewriter", size: 24))
            .fontWeight(.regular)
            .foregroundColor(Color("text"))
            .padding(4)
        }
        Spacer()
      }
      .onTapGesture {
        viewStore.send(.checkboxTapped)
      }
    }
  }
}

//#if DEBUG
//struct ShoppingListRow_Previews : PreviewProvider {
//  static var previews: some View {
//    ShoppingListRow(toDo: ToDo(category: "Shopping", description: "Lettuce", done: "false", shoppingCategory: "Vegetables"))
//  }
//}
//#endif
