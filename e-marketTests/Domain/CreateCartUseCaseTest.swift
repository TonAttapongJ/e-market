//
//  CreateCartUseCaseTest.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import XCTest
import Combine
@testable import e_market

final class CreateCartUseCaseTest: XCTestCase {
  var cancellables = Set<AnyCancellable>()
  var mockRepository: MockCartRepository!
  var useCase: CreateCartUseCase!

  override func setUp() {
      super.setUp()
      mockRepository = MockCartRepository()
      useCase = CreateCartUseCaseImpl(repository: mockRepository)
  }

  override func tearDown() {
      mockRepository = nil
      useCase = nil
      cancellables = []
      super.tearDown()
  }

  func testCreateCartSuccess() {
      // Given
      let product = ProductModel(id: 1, name: "Test Product", price: 50.0, imageUrl: "testImage", quantity: 2)
      let quantity = 3
      mockRepository.createReturnValue = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()

      // When
      let expectation = XCTestExpectation(description: "Create cart completes")
      useCase.execute(product: product, quantity: quantity)
          .sink(receiveCompletion: { _ in
              expectation.fulfill()
          }, receiveValue: { _ in })
          .store(in: &cancellables)

      // Then
      wait(for: [expectation], timeout: 1)
      XCTAssertEqual(mockRepository.createCallsCount, 1, "Create function in repository should be called once")
  }

  func testCreateCartFailure() {
      // Given
      let product = ProductModel(id: 1, name: "Test Product", price: 50.0, imageUrl: "testImage", quantity: 2)
      let quantity = 3
      mockRepository.createReturnValue = Fail(error: NSError(domain: "MockError", code: 500, userInfo: nil)).eraseToAnyPublisher()

      // When
      let expectation = XCTestExpectation(description: "Create cart completes")
      useCase.execute(product: product, quantity: quantity)
          .sink(receiveCompletion: { completion in
            let expectedError = NSError(domain: "MockError", code: 500, userInfo: nil)
              if case .failure(let error) = completion {
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                  expectation.fulfill()
              }
          }, receiveValue: { _ in })
          .store(in: &cancellables)

      // Then
      wait(for: [expectation], timeout: 1)
      XCTAssertEqual(mockRepository.createCallsCount, 1, "Create function in repository should be called once")
  }
}
