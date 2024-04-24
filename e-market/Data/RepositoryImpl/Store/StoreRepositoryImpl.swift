//
//  StoreRepositoryImpl.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

class StoreRepositoryImpl: StoreRepository {
  private let networkManager: NetworkManagerProtocol
  
  public init(
    networkManager: NetworkManagerProtocol = NetworkManager()
  ) {
    self.networkManager = networkManager
  }

  func getStoreInformation() -> AnyPublisher<StoreResponse?, any Error> {
    return networkManager.request(target: StoreAPI.getStoreInformation())
      .eraseToAnyPublisher()
  }
}
