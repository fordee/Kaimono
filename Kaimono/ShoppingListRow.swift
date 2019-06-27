//
//  ShoppingListRow.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI

struct ShoppingListRow : View {
  var itemName: String
  var bought = false
  var body: some View {
    HStack {
      if bought {
        Image(systemName: "checkmark.circle")
        Text(itemName)
          .font(.headline)
          .fontWeight(.semibold)
          .strikethrough()
          .padding(4)
      } else {
        Image(systemName: "circle")
        Text(itemName)
          .font(.headline)
          .fontWeight(.semibold)
          .padding(4)
      }
    }
  }
}

#if DEBUG
struct ShoppingListRow_Previews : PreviewProvider {
  static var previews: some View {
    List {
    ShoppingListRow(itemName: "Test 1", bought: false)
      .previewLayout(.sizeThatFits)
    ShoppingListRow(itemName: "Test 2", bought: true)
      .previewLayout(.sizeThatFits)
    }
  }
}
#endif
