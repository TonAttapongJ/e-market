//
//  AddToCartViewModel.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

class AddToCartViewModel: ObservableObject {
  @Published var productModel: ProductModel
  @Published var quantity: Int = 1
  @Published var addToCartSuccess = false
  let createCartUseCase: CreateCartUseCase
  private var anyCancellable = Set<AnyCancellable>()

  init(
    productModel: ProductModel,
    createCartUseCase: CreateCartUseCase = CreateCartUseCaseImpl()
  ) {
    self.productModel = productModel
    self.createCartUseCase = createCartUseCase
  }
  
  func addToCart() {
    self.createCartUseCase
      .execute(product: self.productModel, quantity: self.quantity)
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
          switch completion {
          case .finished:
              print("Add to cart successfully")
            self.addToCartSuccess = true
          case .failure(let error):
            self.addToCartSuccess = false
              print("Error adding to cart: \(error.localizedDescription)")
          }
      }, receiveValue: { _ in })
      .store(in: &anyCancellable)

  }
}
