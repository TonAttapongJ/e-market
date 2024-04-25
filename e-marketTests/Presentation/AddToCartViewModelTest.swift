//
//  AddToCartViewModelTest.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//
@testable import e_market
import XCTest
import Combine

final class AddToCartViewModelTest: XCTestCase {
  var viewModel: AddToCartViewModel!
  var createCartUseCase: MockCreateCartUseCase!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    cancellables = Set<AnyCancellable>()
    createCartUseCase = MockCreateCartUseCase()
    viewModel = AddToCartViewModel(productModel: ProductModel(name: "product1", price: 50, imageUrl: "image1"), createCartUseCase: createCartUseCase)
  }
  
  override func tearDown() {
    viewModel = nil
    createCartUseCase = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testAddToCartSuccess() {
    // Given
    viewModel.productModel = ProductModel(id: 1, name: "Test Product", price: 10.0, imageUrl: "testImage", quantity: 1)
    viewModel.quantity = 1
    createCartUseCase.executeReturnValue = Just(())
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    let expectation = XCTestExpectation(description: "Add cart completes")

    // When
    viewModel.addToCart()
    
    // Then
    DispatchQueue.global().async {
        sleep(1)
      XCTAssertTrue(self.viewModel.addToCartSuccess)
        expectation.fulfill()
    }
    wait(for: [expectation], timeout: 2)
  }
  
  func testAddToCartFailure() {
    // Given
    viewModel.productModel = ProductModel(id: 1, name: "Test Product", price: 10.0, imageUrl: "testImage", quantity: 1)
    viewModel.quantity = 1
    createCartUseCase.executeReturnValue = Result<Void, Error>.failure(NSError(domain: "TestError", code: 123, userInfo: nil)).publisher.mapError { $0 }.eraseToAnyPublisher()

    // When
    viewModel.addToCart()
    
    // Then
    XCTAssertFalse(viewModel.addToCartSuccess)
  }
  
}
