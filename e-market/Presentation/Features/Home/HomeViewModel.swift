//
//  HomeViewModel.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  // MARK: - UseCase
  private let getStoreUseCase: GetStoreUseCase
  private let getProductUseCase: GetProductUseCase

  // MARK: - Publisher
  @Published private(set) var viewState: ViewState = .start
  @Published private(set) var storeModel: StoreModel?
  @Published private(set) var productModels: [ProductModel] = []
  @Published private(set) var errorMessage: String = ""
  
  private var selectedProduct: ProductModel?
  private var anyCancellable = Set<AnyCancellable>()

  init(
    getStoreUseCase: GetStoreUseCase = GetStoreUseCaseImpl(),
    getProductUseCase: GetProductUseCase = GetProductUseCaseImpl()
  ) {
    self.getStoreUseCase = getStoreUseCase
    self.getProductUseCase = getProductUseCase
    self.getStoreInformation()
  }
  
  private func getStoreInformation() {
    self.viewState = .loading
    self.getStoreUseCase
      .execute()
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .flatMap { [weak self] storeData -> AnyPublisher<[ProductModel]?, Error> in
        guard let self, let storeData else { return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher() }
          self.storeModel = storeData
        return self.getProductUseCase
          .execute()
          .eraseToAnyPublisher()
      }
      .sink(receiveCompletion: { completion in
          switch completion {
          case .failure(let error):
            self.errorMessage = error.localizedDescription
          case .finished:
              break
          }
      }, receiveValue: { [weak self] productModelsData in
        self?.productModels = productModelsData ?? []
        self?.viewState = (productModelsData?.count ?? 0) > 0 ? .success : .failed
      })
      .store(in: &anyCancellable)
  }
  
  func setSelectedProduct(product: ProductModel) {
    selectedProduct = product
  }
}

//MARK: - Make ViewModel
extension HomeViewModel {
  func makeProductCardViewModel(product: ProductModel) -> ProductCardViewModel {
    return ProductCardViewModel(
      displayViewModel: DisplayProductCardViewModel(
        name: product.name,
        price: "\(product.price)",
        imageUrl: product.imageUrl))
  }
  
  func makeAddToCartViewModel() -> AddToCartViewModel {
    guard let selectedProduct = self.selectedProduct else { return AddToCartViewModel(productModel: ProductModel(name: "", price: 0, imageUrl: "")) }
    return AddToCartViewModel(productModel: selectedProduct)
  }
}
