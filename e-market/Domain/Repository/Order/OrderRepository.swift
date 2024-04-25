//
//  OrderRepository.swift
//  e-market
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Combine

protocol OrderRepository {
  func post(products: [ProductModel], address: String) -> AnyPublisher<Void, Error>
}
