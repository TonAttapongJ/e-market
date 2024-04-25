//
//  OrderSummaryViewModelTest.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import XCTest

@testable import e_market
import XCTest
import Combine

final class OrderSummaryViewModelTest: XCTestCase {
  var viewModel: OrderSummaryViewModel!
  var useCase: MockPostOrderUseCase!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    cancellables = Set<AnyCancellable>()
    useCase = MockPostOrderUseCase()
    viewModel = OrderSummaryViewModel(productModels: [ProductModel(name: "abc", price: 50, imageUrl: "image1")], orderPostUseCase: useCase)
  }
  
  override func tearDown() {
    viewModel = nil
    useCase = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testPostOrderSuccess() {
    // Given
    useCase.executeReturnValue = Just(())
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    let expectation = XCTestExpectation(description: "post Order completes")

    // When
    viewModel.confirmOrder()
    
    // Then
    DispatchQueue.global().async {
        sleep(2)
        XCTAssertFalse(self.viewModel.isShowError)
        expectation.fulfill()
    }
    wait(for: [expectation], timeout: 4)
  }
  
  func testPostOrderFailure() {
    // Given
    useCase.executeReturnValue = Result<Void, Error>.failure(NSError(domain: "TestError", code: 123, userInfo: nil)).publisher.mapError { $0 }.eraseToAnyPublisher()
    let expectation = XCTestExpectation(description: "post Order failed")

    // When
    viewModel.confirmOrder()
    
    // Then
    DispatchQueue.global().async {
      sleep(2)
      XCTAssertTrue(self.viewModel.isShowError)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 4)
  }
  
}
