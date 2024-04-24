//
//  ProductModel.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation

struct ProductModel {
  let name: String
  let price: Double
  let imageUrl: String
  
  init(name: String, price: Double, imageUrl: String) {
    self.name = name
    self.price = price
    self.imageUrl = imageUrl
  }
}
