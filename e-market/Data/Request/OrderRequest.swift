//
//  OrderRequest.swift
//  e-market
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation

struct OrderRequest: Encodable {
  let products: [ProductRequest]
  let deliveryAddress: String
  
  enum CodingKeys: String, CodingKey {
    case deliveryAddress = "delivery_address"
  }
  
  init(products: [ProductRequest], deliveryAddress: String) {
    self.products = products
    self.deliveryAddress = deliveryAddress
  }
}

struct ProductRequest: Encodable {
  let name: String
  let price: Double
  let imageUrl: String
  
  init(name: String, price: Double, imageUrl: String) {
    self.name = name
    self.price = price
    self.imageUrl = imageUrl
  }
}
