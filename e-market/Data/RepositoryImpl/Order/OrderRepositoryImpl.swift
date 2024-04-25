//
//  OrderRepositoryImpl.swift
//  e-market
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Combine

class OrderRepositoryImpl: OrderRepository {
  private let networkManager: NetworkManagerProtocol
  
  public init(
    networkManager: NetworkManagerProtocol = NetworkManager()
  ) {
    self.networkManager = networkManager
  }

  func post(products: [ProductModel], address: String) -> AnyPublisher<Void, Error> {
    let productRequest = products.map { product in
        ProductRequest(name: product.name, price: product.price, imageUrl: product.imageUrl)
    }

    let orderRequest = OrderRequest(products: productRequest, deliveryAddress: address)
    return networkManager.request(target: OrderAPI.postOrder(orderRequest: orderRequest)).eraseToAnyPublisher()
  }
}
