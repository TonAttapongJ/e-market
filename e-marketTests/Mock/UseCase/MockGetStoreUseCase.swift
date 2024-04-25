//
//  MockGetStoreUseCase.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//
@testable import e_market
import Foundation
import Combine

class MockGetStoreUseCase: GetStoreUseCase {
  var executeReturnValue: AnyPublisher<StoreModel?, Error>?
  
  func execute() -> AnyPublisher<StoreModel?, Error> {
    return executeReturnValue ?? Fail(error: NSError(domain: "MockError", code: 101, userInfo: nil)).eraseToAnyPublisher()
  }
}
