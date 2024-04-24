//
//  ProductModel.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation

struct ProductModel {
  let id: Int
  let name: String
  let price: Double
  let imageUrl: String
  var quantity: Int
  
  init(id: Int = UUID().hashValue, name: String, price: Double, imageUrl: String, quantity: Int = 0) {
    self.id = id
    self.name = name
    self.price = price
    self.imageUrl = imageUrl
    self.quantity = quantity
  }
}
