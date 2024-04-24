//
//  ReadCartUseCase.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

protocol ReadCartUseCase {
  func execute() -> AnyPublisher<[ProductModel], Error>
}

class ReadCartUseCaseImpl: ReadCartUseCase {
  let respository: CartRepository
  
  init(respository: CartRepository = CartRepositoryImpl()) {
    self.respository = respository
  }
  
  func execute() -> AnyPublisher<[ProductModel], Error> {
    return self.respository.read().eraseToAnyPublisher()
  }
}
