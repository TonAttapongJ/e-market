//
//  StoreModel.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation

struct StoreModel {
  let name: String
  let rating: Double
  let openingTime: String
  let closingTime: String
  
  init(name: String, rating: Double, openingTime: String, closingTime: String) {
    self.name = name
    self.rating = rating
    self.openingTime = openingTime
    self.closingTime = closingTime
  }
}
