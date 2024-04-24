//
//  GetStoreUseCase.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

protocol GetStoreUseCase {
  func execute() -> AnyPublisher<StoreModel?, Error>
}

final class GetStoreUseCaseImpl: GetStoreUseCase {
  private let repository: StoreRepository
  
  init(repository: StoreRepository = StoreRepositoryImpl()) {
    self.repository = repository
  }
  
  func execute() -> AnyPublisher<StoreModel?, Error> {
    return repository.getStoreInformation()
      .map { response in
        return self.mapResponse(response)
      }
      .eraseToAnyPublisher()
  }
  
  private func mapResponse(_ response: StoreResponse?) -> StoreModel? {
    guard let response else { return nil }
    return StoreModel(
      name: response.name,
      rating: response.rating,
      openingTime: response.openingTime,
      closingTime: response.closingTime)
  }
}
