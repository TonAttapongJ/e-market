//
//  OrderPostUseCase.swift
//  e-market
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Combine

protocol OrderPostUseCase {
  func execute(products: [ProductModel], address: String) -> AnyPublisher<Void, Error>
}

class OrderPostUseCaseImpl: OrderPostUseCase {
  let repository: OrderRepository
  
  init(repository: OrderRepository = OrderRepositoryImpl()) {
    self.repository = repository
  }
  
  func execute(products: [ProductModel], address: String) -> AnyPublisher<Void, any Error> {
    return repository.post(products: products, address: address)
  }
}
