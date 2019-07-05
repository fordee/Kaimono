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

final class Resource<A>: BindableObject {
  let didChange = PassthroughSubject<A?, Never>()
  let endpoint: Endpoint<A>
  var completion: (() -> Void)?
  var value: A? {
    didSet {
      DispatchQueue.main.async {
        self.didChange.send(self.value)
      }
    }
  }
  
  init(endpoint: Endpoint<A>, completion: (() -> Void)? = nil) {
    self.endpoint = endpoint
    self.completion = completion
    reload()
  }
  
  func reload() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 20 * 60 // 20 min
    let session = URLSession(configuration: configuration)
    
    session.load(endpoint) { result in
      do {
        self.value = try result.get()
      } catch let error {
        print("Error: \(error)")
      }
      print("endpoint: \(self.endpoint)")
      print("value: \(String(describing: self.value))")
      if let completion = self.completion {
        completion()
      }
    }
  }
}
