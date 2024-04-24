//
//  ProductRepository.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

protocol ProductRepository {
  func getProducts() -> AnyPublisher<[ProductResponse]?, Error>
}
