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
          TextField("Shopping Item", text: viewStore.binding(
                                                              get: \.shoppingItem,
                                                              send: AppAction.editText
                                                            ))
            .font(.custom("American Typewriter", size: 24))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.top, 8).padding(.leading).padding(.trailing).padding(.bottom, 8)
            .foregroundColor(Color("text"))
          List {
            ForEach(Array(viewStore.frequentItems.enumerated()), id: \.element.id) { index, frequesntItem in
              Text(frequesntItem.shoppingItem)
                .font(.custom("American Typewriter", size: 24))
                .fontWeight(.regular)
                .foregroundColor(Color("text"))
                .padding(4)
                .onTapGesture {
                  viewStore.send(.frequentItem(index: index, text: frequesntItem.shoppingItem))
                }
            }
          }
        }.onAppear {
          viewStore.send(.getFrequentItems)
        }
        .navigationBarTitle(Text("Add Shopping Item"), displayMode: .inline)
        .navigationBarItems(
          trailing: Button(action: {
            //self.store.dispatch(action: ShoppingActions.AddToDo(item: self.toDo))
            viewStore.send(.addItem)
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
      }
  }
  
//  private func dismiss() {
//    presentationMode.wrappedValue.dismiss()
//  }
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
