//
//  CartViewModelTest.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

@testable import e_market
import XCTest
import Combine

final class CartViewModelTest: XCTestCase {
  var viewModel: CartViewModel!
  var mockUpdateCartUseCase: MockUpdateCartUseCase!
  var mockReadCartUseCase: MockReadCartUseCase!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    cancellables = Set<AnyCancellable>()
    mockUpdateCartUseCase = MockUpdateCartUseCase()
    mockReadCartUseCase = MockReadCartUseCase()
    viewModel = CartViewModel(readCartUseCase: mockReadCartUseCase, updateCartUseCase: mockUpdateCartUseCase)
  }
  
  override func tearDown() {
    viewModel = nil
    mockUpdateCartUseCase = nil
    mockReadCartUseCase = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testReadCartSuccess() {
    // Given
    mockReadCartUseCase.executeReturnValue = Just(([ProductModel(id: 1, name: "Test Product", price: 10.0, imageUrl: "testImage", quantity: 1)]))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    let expectation = XCTestExpectation(description: "Read cart completes")
    
    // When
    viewModel.getProductsOnCart()
    
    // Then
    DispatchQueue.global().async {
      sleep(1)
      XCTAssertTrue(!self.viewModel.productModels.isEmpty)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 2)
  }
  
  func testReadCartFailure() {
    // Given
    mockReadCartUseCase.executeReturnValue = Result<[ProductModel], Error>.failure(NSError(domain: "TestError", code: 123, userInfo: nil))
      .publisher
      .mapError { $0 }
      .eraseToAnyPublisher()
    let expectation = XCTestExpectation(description: "Read cart failed")
    
    // When
    viewModel.getProductsOnCart()
    
    // Then
    DispatchQueue.global().async {
      sleep(1)
      XCTAssertTrue(self.viewModel.productModels.isEmpty)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 2)
  }
  
  func testUpdateCartSuccess() {
    // Given
    let product = ProductModel(id: 1, name: "Test Product", price: 10.0, imageUrl: "testImage", quantity: 1)
    let quantity = 1
    mockUpdateCartUseCase.executeReturnValue = Just(())
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    let expectation = XCTestExpectation(description: "Update cart completes")

    // When
    viewModel.updateProduct(product: product, quantity: quantity)
    
    // Then
    DispatchQueue.global().async {
        sleep(2)
        XCTAssertFalse(self.viewModel.isUpdating)
        expectation.fulfill()
    }
    wait(for: [expectation], timeout: 4)
  }
  
  func testUpdateCartFailure() {
    // Given
    let product = ProductModel(id: 1, name: "Test Product", price: 10.0, imageUrl: "testImage", quantity: 1)
    let quantity = 1
    mockUpdateCartUseCase.executeReturnValue = Result<Void, Error>.failure(NSError(domain: "TestError", code: 123, userInfo: nil))
      .publisher
      .mapError { $0 }
      .eraseToAnyPublisher()
    let expectation = XCTestExpectation(description: "Update cart failed")
    
    // When
    viewModel.updateProduct(product: product, quantity: quantity)
    
    // Then
    DispatchQueue.global().async {
      sleep(2)
      XCTAssertTrue(self.viewModel.isShowError)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 4)
  }

}
