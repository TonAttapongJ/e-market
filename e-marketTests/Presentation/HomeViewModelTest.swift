//
//  HomeViewModelTest.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

@testable import e_market
import XCTest
import Combine

final class HomeViewModelTest: XCTestCase {
  var viewModel: HomeViewModel!
  var mockGetStoreUseCase: MockGetStoreUseCase!
  var mockGetProductUseCase: MockGetProductUseCase!
  var mockReadCartUseCase: MockReadCartUseCase!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    cancellables = Set<AnyCancellable>()
    mockGetStoreUseCase = MockGetStoreUseCase()
    mockGetProductUseCase = MockGetProductUseCase()
    mockReadCartUseCase = MockReadCartUseCase()
    viewModel = HomeViewModel(
      getStoreUseCase: mockGetStoreUseCase,
      getProductUseCase: mockGetProductUseCase,
      readCartUseCase: mockReadCartUseCase
    )
  }
  
  override func tearDown() {
    viewModel = nil
    mockGetStoreUseCase = nil
    mockGetProductUseCase = nil
    mockReadCartUseCase = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testReadCart() {
    // Given
    let products: [ProductModel] = [
      ProductModel(id: 1, name: "Product 1", price: 50.0, imageUrl: "image1", quantity: 2),
      ProductModel(id: 2, name: "Product 2", price: 75.0, imageUrl: "image2", quantity: 3)
    ]
    mockReadCartUseCase.executeReturnValue = Just(products)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    let expectation = XCTestExpectation(description: "Read cart completes")

    // When
    viewModel.readCart()
    
    // Then
    DispatchQueue.global().async {
        sleep(1)
        XCTAssertEqual(self.viewModel.badge, 5, "Badge count should be sum of quantities of products in the cart")
        expectation.fulfill()
    }
    wait(for: [expectation], timeout: 2)
  }
  
  func testGetStoreInformation() {
    // Given
    let storeData = StoreModel(name: "Test Store", rating: 4.5, openingTime: "3PM", closingTime: "7PM")
    mockGetStoreUseCase.executeReturnValue = Just(storeData)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    let productModels: [ProductModel] = [
      ProductModel(id: 1, name: "Product 1", price: 50.0, imageUrl: "image1", quantity: 2),
      ProductModel(id: 2, name: "Product 2", price: 75.0, imageUrl: "image2", quantity: 3)
    ]
    mockGetProductUseCase.executeReturnValue = Just(productModels)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    let expectation = XCTestExpectation(description: "Get store information completes")

    // When
    viewModel.getStoreInformation()
    
    // Then
    DispatchQueue.global().async {
        sleep(1)
        XCTAssertEqual(self.viewModel.storeModel, storeData, "Store model should be set correctly")
        XCTAssertEqual(self.viewModel.productModels, productModels, "Product models should be set correctly")
        XCTAssertEqual(self.viewModel.viewState, .success, "View state should be success when product models are retrieved")
        XCTAssert(self.viewModel.errorMessage.isEmpty, "Error message should be empty on success")
        expectation.fulfill()
    }
    wait(for: [expectation], timeout: 4)
  }
  
  func testSetSelectedProduct() {
    // Given
    let product = ProductModel(id: 1, name: "Test Product", price: 50.0, imageUrl: "image1", quantity: 2)
        
    // When
    viewModel.setSelectedProduct(product: product)
    
    // Then
    XCTAssertEqual(viewModel.selectedProduct, product, "Selected product should be set correctly")
  }
  
  func testMakeProductCardViewModel() {
      // Given
      let product = ProductModel(id: 1, name: "Test Product", price: 50.0, imageUrl: "image1", quantity: 2)
      
      // When
      let productCardViewModel = viewModel.makeProductCardViewModel(product: product)
      
      // Then
      XCTAssertEqual(productCardViewModel.displayViewModel.name, "Test Product", "Product name should be set correctly")
      XCTAssertEqual(productCardViewModel.displayViewModel.price, "50.0", "Product price should be set correctly")
      XCTAssertEqual(productCardViewModel.displayViewModel.imageUrl, "image1", "Product imageUrl should be set correctly")
  }

  func testMakeAddToCartViewModel() {
      // Given
      let product = ProductModel(id: 1, name: "Test Product", price: 50.0, imageUrl: "image1", quantity: 2)
      viewModel.setSelectedProduct(product: product)
      
      // When
      let addToCartViewModel = viewModel.makeAddToCartViewModel()
      
      // Then
      XCTAssertEqual(addToCartViewModel.productModel, product, "Selected product in AddToCartViewModel should be set correctly")
  }

}
