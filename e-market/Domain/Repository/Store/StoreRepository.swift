//
//  StoreRepository.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

protocol StoreRepository {
  func getStoreInformation() -> AnyPublisher<StoreResponse?, Error>
}
