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
  @Published var isUpdating: Bool = false
  
  private let readCartUseCase: ReadCartUseCase
  private let updateCartUseCase: UpdateCartUseCase
  private var anyCancellable = Set<AnyCancellable>()

  init(
    readCartUseCase: ReadCartUseCase = ReadCartUseCaseImpl(),
    updateCartUseCase: UpdateCartUseCase = UpdateCartUseCaseImpl()
  ) {
    self.readCartUseCase = readCartUseCase
    self.updateCartUseCase = updateCartUseCase
    getProductsOnCart()
  }
  
  func getProductsOnCart() {
    self.viewState = .loading
    self.readCartUseCase
      .execute()
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .sink { completion in
      } receiveValue: { products in
        self.productModels = products
        self.viewState = products.count > 0 ? .success : .failed
      }.store(in: &anyCancellable)
  }
  
  func updateProduct(product: ProductModel, quantity: Int) {
    self.isUpdating = true
    updateCartUseCase
      .execute(product: product, quantity: quantity)
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .sink { completion in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.isUpdating = false
          self.getProductsOnCart()
        }
      } receiveValue: { _ in }
      .store(in: &anyCancellable)
  }
}
