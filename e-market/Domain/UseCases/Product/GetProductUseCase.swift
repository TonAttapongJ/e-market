//
//  ProductUseCase.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

protocol GetProductUseCase {
  func execute() -> AnyPublisher<[ProductModel]?, Error>
}

final class GetProductUseCaseImpl: GetProductUseCase {
  private let repository: ProductRepository
  
  init(repository: ProductRepository = ProductRepositoryImpl()) {
    self.repository = repository
  }
  
  func execute() -> AnyPublisher<[ProductModel]?, Error> {
    return repository.getProducts()
      .compactMap { response in
        return self.mapResponse(response)
      }
      .eraseToAnyPublisher()
  }
  
  private func mapResponse(_ response: [ProductResponse]?) -> [ProductModel]? {
    guard let response else { return nil }
    return response.map { ProductModel(
      name: $0.name,
      price: $0.price,
      imageUrl: $0.imageUrl)}
  }
}
