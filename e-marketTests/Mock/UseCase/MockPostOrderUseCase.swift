//
//  MockPostOrderUseCase.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

@testable import e_market
import Foundation
import Combine

class MockPostOrderUseCase: OrderPostUseCase {
  var executeCalled = false
  var executeReceivedArguments: (products: [ProductModel], address: String)?
  var executeReturnValue: AnyPublisher<Void, Error>?
    
  func execute(products: [e_market.ProductModel], address: String) -> AnyPublisher<Void, any Error> {
    executeCalled = true
    executeReceivedArguments = (products, address)
    return executeReturnValue ?? Fail(error: NSError(domain: "MockError", code: 101, userInfo: nil)).eraseToAnyPublisher()
  }
}
