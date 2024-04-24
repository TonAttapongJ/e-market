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
  private let readCartUseCase: ReadCartUseCase

  // MARK: - Publisher
  @Published private(set) var viewState: ViewState = .start
  @Published private(set) var storeModel: StoreModel?
  @Published private(set) var productModels: [ProductModel] = []
  @Published private(set) var errorMessage: String = ""
  @Published private(set) var badge: Int? = nil
  
  private var selectedProduct: ProductModel?
  private var anyCancellable = Set<AnyCancellable>()

  init(
    getStoreUseCase: GetStoreUseCase = GetStoreUseCaseImpl(),
    getProductUseCase: GetProductUseCase = GetProductUseCaseImpl(),
    readCartUseCase: ReadCartUseCase = ReadCartUseCaseImpl()
  ) {
    self.getStoreUseCase = getStoreUseCase
    self.getProductUseCase = getProductUseCase
    self.readCartUseCase = readCartUseCase
    self.getStoreInformation()
  }
  
  func readCart() {
    self.readCartUseCase
      .execute()
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .sink { completion in
      } receiveValue: { products in
        let totalQuantity = products.reduce(0) { $0 + $1.quantity }
        self.badge = totalQuantity
      }.store(in: &anyCancellable)
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
