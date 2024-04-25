//
//  MockCartRepository.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Combine
@testable import e_market

class MockCartRepository: CartRepository {
  
  var createCallsCount = 0
  var createReturnValue: AnyPublisher<Void, Error>?
  var readCallsCount = 0
  var readReturnValue: AnyPublisher<[ProductModel], Error>?
  var updateCallsCount = 0
  var updateReturnValue: AnyPublisher<Void, Error>?
  
  func create(product: ProductModel, quantity: Int) -> AnyPublisher<Void, Error> {
    createCallsCount += 1
    return createReturnValue ?? Empty().eraseToAnyPublisher()
  }
  
  func read() -> AnyPublisher<[ProductModel], Error> {
    readCallsCount += 1
    return readReturnValue ?? Empty().eraseToAnyPublisher()
  }
  
  func update(product: ProductModel, quantity: Int) -> AnyPublisher<Void, Error> {
    updateCallsCount += 1
    return updateReturnValue ?? Empty().eraseToAnyPublisher()
  }
  func delete(product: e_market.ProductModel) -> AnyPublisher<Void, any Error> {
    updateCallsCount = 0
    return updateReturnValue ?? Empty().eraseToAnyPublisher()
  }

}
