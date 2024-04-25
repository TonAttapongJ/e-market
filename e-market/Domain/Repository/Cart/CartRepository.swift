//
//  CartRepository.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

protocol CartRepository {
  func create(product: ProductModel, quantity: Int) -> AnyPublisher<Void, Error>
  func read() -> AnyPublisher<[ProductModel], Error>
  func update(product: ProductModel, quantity: Int) -> AnyPublisher<Void, Error>
  func delete(product: ProductModel) -> AnyPublisher<Void, Error>
  func deleteAll() -> AnyPublisher<Void, Error>
}
