//
//  MockCreateCartUseCase.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

@testable import e_market
import Foundation
import Combine

class MockCreateCartUseCase: CreateCartUseCase {
  var executeCalled = false
  var executeReceivedArguments: (product: ProductModel, quantity: Int)?
  var executeReturnValue: AnyPublisher<Void, Error>?
  
  func execute(product: ProductModel, quantity: Int) -> AnyPublisher<Void, Error> {
    executeCalled = true
    executeReceivedArguments = (product, quantity)
    return executeReturnValue ?? Fail(error: NSError(domain: "MockError", code: 101, userInfo: nil)).eraseToAnyPublisher()
  }
}
