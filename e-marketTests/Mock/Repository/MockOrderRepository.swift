//
//  MockOrderRepository.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Combine
@testable import e_market

class MockOrderRepository: OrderRepository {
  var postOrderCallsCount = 0
  var postOrderReturnValue: AnyPublisher<Void, Error> = Empty().eraseToAnyPublisher()
  
  func post(products: [e_market.ProductModel], address: String) -> AnyPublisher<Void, any Error> {
    postOrderCallsCount += 1
    return postOrderReturnValue
  }

}
