//
//  MockStoreRepository.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Combine
@testable import e_market

class MockStoreRepository: StoreRepository {
  var getStoreCallsCount = 0
  var getStoreInformationReturnValue: AnyPublisher<StoreResponse?, Error> = Empty().eraseToAnyPublisher()
  
  func getStoreInformation() -> AnyPublisher<StoreResponse?, Error> {
    self.getStoreCallsCount += 1
    return getStoreInformationReturnValue
  }
}
