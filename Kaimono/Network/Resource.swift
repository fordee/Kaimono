//
//  Resource.swift
//  SwiftTalk2
//
//  Created by Chris Eidhof on 27.06.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class Resource<A>: ObservableObject {
  var objectWillChange: AnyPublisher<A?, Never> = Publishers.Sequence<[A?], Never>(sequence: []).eraseToAnyPublisher()
  @Published var value: A? = nil
  let endpoint: Endpoint<A>
  var completion: (() -> Void)?
  
  init(endpoint: Endpoint<A>, completion: (() -> Void)? = nil) {
    self.endpoint = endpoint
    self.completion = completion
    self.objectWillChange = $value.handleEvents(receiveSubscription: { [weak self] sub in
                guard let s = self else { return }
                s.reload()
    }).eraseToAnyPublisher()
  }
  
  func reload() {
    URLSession.shared.load(endpoint) { result in
      DispatchQueue.main.async {
        do {
          self.value = try result.get()
        } catch let error {
          print("Error: \(error)")
        }
      }
      print("endpoint: \(self.endpoint)")
      print("value: \(String(describing: self.value))")
      if let completion = self.completion {
        DispatchQueue.main.async {
          completion()
        }
      }
    }
  }
}
