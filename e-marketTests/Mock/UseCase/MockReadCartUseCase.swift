//
//  MockReadCartUseCase.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

@testable import e_market
import Foundation
import Combine

class MockReadCartUseCase: ReadCartUseCase {
  var executeReturnValue: AnyPublisher<[ProductModel], Error>?
  
  func execute() -> AnyPublisher<[ProductModel], Error> {
    return executeReturnValue ?? Fail(error: NSError(domain: "MockError", code: 103, userInfo: nil)).eraseToAnyPublisher()
  }
}
