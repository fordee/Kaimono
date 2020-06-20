//
//  ContentView.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import SwiftUI
import ComposableArchitecture


// MARK: - ToDo feature domain
struct AppState: Equatable {
  var toDos: [ToDo] = []
  var frequentItems: [FrequentItem] = []
  var isSheetPresented = false
  var shoppingItem = ""
}

struct ContentView : View {
  let store: Store<AppState, AppAction>
  
  @State var showingAddItemView = false
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        
        List {
          ForEachStore(
            self.store.scope(state: \.toDos, action: AppAction.toDo(index:action:)),
            content: ShoppingListRow.init(store:)
          )
        }
        .navigationBarTitle("買い物")
        .navigationBarItems(
          leading: HStack(spacing: 16.0) {
            Button(action: {
              viewStore.send(.fetchAll)
            }) {
              Image(systemName: "arrow.clockwise")
                .imageScale(.large)
            }
            Button(action: {
              viewStore.send(.deleteButtonTapped)
            }) {
              Image(systemName: "trash")
                .imageScale(.large)
            }
          },
          trailing: Button(action: {
            self.showingAddItemView.toggle()
          }) {
            Image(systemName: "plus")
              .imageScale(.large)
          })
          .sheet(isPresented: self.$showingAddItemView) {
            AddShoppingItemView.init(store: self.store)
          }
          .onAppear() {
            viewStore.send(.fetchAll)
        }
        .navigationViewStyle(StackNavigationViewStyle())
      }
    }
  }
}

#if DEBUG

struct ContentView_Previews : PreviewProvider {
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
        }
          , updateToDos: { _ in
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
    return ContentView(store: store)
  }
}
#endif
