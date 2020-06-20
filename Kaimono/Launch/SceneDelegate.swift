//
//  SceneDelegate.swift
//  Kaimono
//
//  Created by John Forde on 28/06/19.
//  Copyright © 2019 John Forde. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // Use a UIHostingController as window root view controller
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      
    
      let controller = UIHostingController(rootView: ContentView(store:
        Store(initialState: AppState(),
              reducer: appReducer,//.debug(),
              environment: AppEnvironment(toDoClient: ToDoClient.live,
                                          mainQueue: DispatchQueue.main.eraseToAnyScheduler())
            )))

      window.rootViewController = controller
      self.window = window
      window.makeKeyAndVisible()
    }
  }

  
  
  
}

