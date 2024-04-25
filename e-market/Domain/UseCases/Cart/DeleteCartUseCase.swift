//
//  DeleteCartUseCase.swift
//  e-market
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Combine

protocol DeleteCartUseCase {
  func execute() -> AnyPublisher<Void, Error>
}

class DeleteCartUseCaseImpl: DeleteCartUseCase {
  let repository: CartRepository
  
  init(repository: CartRepository = CartRepositoryImpl()) {
    self.repository = repository
  }
  
  func execute() -> AnyPublisher<Void, any Error> {
    return self.repository.deleteAll().eraseToAnyPublisher()
  }
}
