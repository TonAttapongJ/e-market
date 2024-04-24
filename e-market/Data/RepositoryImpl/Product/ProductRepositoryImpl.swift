//
//  ProductRepositoryImpl.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

class ProductRepositoryImpl: ProductRepository {
  private let networkManager: NetworkManagerProtocol
  
  public init(
    networkManager: NetworkManagerProtocol = NetworkManager()
  ) {
    self.networkManager = networkManager
  }

  func getProducts() -> AnyPublisher<[ProductResponse]?, Error> {
    return networkManager.request(target: ProductAPI.getProducts())
      .eraseToAnyPublisher()
  }
}
