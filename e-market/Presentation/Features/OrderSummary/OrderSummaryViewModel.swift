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
  @Published private(set) var isLoading: Bool = false
  @Published var addressText: String = ""
  @Published var errorMessage: String = ""
  @Published var isShowError: Bool = false
  @Published var isNavigateToSuccessScreen = false

  let orderPostUseCase: OrderPostUseCase
  private var anyCancellable = Set<AnyCancellable>()

  init(
    productModels: [ProductModel],
    orderPostUseCase: OrderPostUseCase = OrderPostUseCaseImpl()
  ) {
    self.orderPostUseCase = orderPostUseCase
    self.productModels = productModels
  }
  
  func confirmOrder() {
    self.isLoading = true
    orderPostUseCase
      .execute(products: productModels, address: addressText)
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .finished:
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.isNavigateToSuccessScreen = true
          }
          self.errorMessage = ""
          self.isShowError = false
        case .failure(let error):
          self.isLoading = false
          self.isShowError = true
          self.errorMessage = error.localizedDescription
        }
      } receiveValue: { _ in }
      .store(in: &anyCancellable)
  }  
}
