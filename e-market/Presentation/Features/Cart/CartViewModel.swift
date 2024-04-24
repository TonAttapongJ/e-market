//
//  CartViewModel.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
  @Published private(set) var viewState: ViewState = .start
  @Published private(set) var productModels: [ProductModel] = []
  let readCartUseCase: ReadCartUseCase
  private var anyCancellable = Set<AnyCancellable>()

  init(readCartUseCase: ReadCartUseCase = ReadCartUseCaseImpl()) {
    self.readCartUseCase = readCartUseCase
    getProductsOnCart()
  }
  
  func getProductsOnCart() {
    self.viewState = .loading
    self.readCartUseCase
      .execute()
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .sink { completion in
        print("completion")
      } receiveValue: { products in
        for product in products {
          print("Product name: \(product.name)")
          print("Product quantity: \(product.quantity)")
        }
        self.productModels = products
        print("productModels count: \(self.productModels.count)")
        self.viewState = products.count > 0 ? .success : .failed
      }.store(in: &anyCancellable)

  }
}
