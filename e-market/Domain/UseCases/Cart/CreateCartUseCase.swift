//
//  CreateCartUseCase.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

protocol CreateCartUseCase {
  func execute(product: ProductModel, quantity: Int) -> AnyPublisher<Void, Error>
}

class CreateCartuseCaseImpl: CreateCartUseCase {
  let repository: CartRepository
  
  init(repository: CartRepository = CartRepositoryImpl()) {
    self.repository = repository
  }
  
  func execute(product: ProductModel, quantity: Int) -> AnyPublisher<Void, any Error> {
    return self.repository.create(product: product, quantity: quantity)
  }
}
