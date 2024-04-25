//
//  MockProductRepository.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Combine
@testable import e_market

class MockProductRepository: ProductRepository {
  var getProductCallsCount = 0
  var getProductsReturnValue: AnyPublisher<[ProductResponse]?, Error> = Empty().eraseToAnyPublisher()
  
  func getProducts() -> AnyPublisher<[ProductResponse]?, Error> {
    getProductCallsCount += 1
    return getProductsReturnValue
  }
}
