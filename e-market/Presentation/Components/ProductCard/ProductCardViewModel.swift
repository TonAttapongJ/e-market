//
//  ProductCardViewModel.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
class ProductCardViewModel: ObservableObject {
  @Published private(set) var displayViewModel: DisplayProductCardViewModel
  
  init(displayViewModel: DisplayProductCardViewModel) {
    self.displayViewModel = displayViewModel
  }
}

//MARK: - Display ViewModel
struct DisplayProductCardViewModel {
  let name: String
  let price: String
  let imageUrl: String
}
