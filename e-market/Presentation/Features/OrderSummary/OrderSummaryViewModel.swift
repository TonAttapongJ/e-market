//
//  OrderSummaryViewModel.swift
//  e-market
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Combine

class OrderSummaryViewModel: ObservableObject {
  @Published private(set) var productModels: [ProductModel] = []
  
  init(productModels: [ProductModel]) {
    self.productModels = productModels
  }
}
