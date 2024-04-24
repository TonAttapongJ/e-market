//
//  UpdateCartUseCase.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

protocol UpdateCartUseCase {
  func execute(product: ProductModel, quantity: Int) -> AnyPublisher<Void, Error>
}

class UpdateCartUseCaseImpl: UpdateCartUseCase {
  let repository: CartRepository
  
  init(repository: CartRepository = CartRepositoryImpl()) {
    self.repository = repository
  }
  
  func execute(product: ProductModel, quantity: Int) -> AnyPublisher<Void, any Error> {
    return self.repository.update(product: product, quantity: quantity)
  }
}
