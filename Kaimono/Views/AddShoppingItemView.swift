//
//  AddShoppingItemView.swift
//  Kaimono
//
//  Created by John Forde on 12/06/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AddShoppingItemView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let store: Store<AppState, AppAction>
  
  var body: some View {
    
    return NavigationView {
      WithViewStore(self.store) { viewStore in
        VStack {
          TextField("Shopping Item", text: .constant("Frequent Item"))
            .font(.custom("American Typewriter", size: 24))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.top, 8).padding(.leading).padding(.trailing).padding(.bottom, 8)
            .background(Color("back"))
            .foregroundColor(Color("text"))
          List {
            ForEachStore(
              self.store.scope(state: \.frequentItems, action: AppAction.toDo(index:action:)),
              content: FrequentItemRow.init(store:)
            )
          }
        }.onAppear {
          viewStore.send(.getFrequentItems)
        }
        .navigationBarTitle(Text("Add Shopping Item"), displayMode: .inline)
        .navigationBarItems(
          //          leading:
          //          Button(action: {
          //            self.dismiss()
          //          }) {
          //            Text("Done")
          //          },
          trailing: Button(action: {
            //self.store.dispatch(action: ShoppingActions.AddToDo(item: self.toDo))
          }) {
            Image(systemName: "plus")
              .imageScale(.large)
      })
      }
    }.navigationViewStyle(StackNavigationViewStyle())
  }
  
  
  private func FrequentItemsRow(_ item: FrequentItem) -> some View {
    
    return Text(item.shoppingItem)
      .font(.custom("American Typewriter", size: 24))
      .fontWeight(.regular)
      .foregroundColor(Color("text"))
      .onTapGesture {
        print("tapped \(item.shoppingItem)")
        //self.toDo = ToDo(category: "Shopping", description: item.shoppingItem, done: "false", shoppingCategory: item.category ?? "No Category")
    }
  }
  
  private func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
}

struct AddShoppingItemView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        toDoClient: ToDoClient(
          getToDos: {
            Effect(value: [
              ToDo(category: "shopping", description: "Eggs", done: "false", shoppingCategory: "Dairy"),
              ToDo(category: "shopping", description: "Milk", done: "false", shoppingCategory: "Dairy"),
              ToDo(category: "shopping", description: "Lamb", done: "false", shoppingCategory: "Meat"),
            ])
        }, getFrequentItems: {
          Effect(value: [FrequentItem(shoppingItem: "Beer")])
        }, updateToDos: { _ in
          Effect(value: ToDo(category: "shopping", description: "Eggs", done: "true", shoppingCategory: "Dairy"))
        }, deleteToDo: { _ in
          Effect(value: "Eggs deleted")
        },
           addToDo: { _ in
            Effect(value: ToDo(category: "shopping", description: "Beef", done: "false", shoppingCategory: "Dairy"))
        }),
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )
    return AddShoppingItemView(store: store)
  }
}
