//
//  PostOrderUseCaseTest.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import XCTest
import Combine
@testable import e_market

final class PostOrderUseCaseTest: XCTestCase {
  var cancellables = Set<AnyCancellable>()
  var mockRepository: MockOrderRepository!
  var useCase: OrderPostUseCase!

  override func setUp() {
    super.setUp()
    mockRepository = MockOrderRepository()
    useCase = OrderPostUseCaseImpl(repository: mockRepository)
  }
  
  override func tearDown() {
    mockRepository = nil
    useCase = nil
    cancellables = []
    super.tearDown()
  }

  func testGetProductSuccess() {
    // Given
    mockRepository.postOrderReturnValue = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    
    // When
    let expectation = XCTestExpectation(description: "Get store completes")
    useCase.execute(products: [ProductModel(name: "abc", price: 50.0, imageUrl: "image1")], address: "1/234")
      .sink(receiveCompletion: { completion in
        expectation.fulfill()
      }, receiveValue: { _ in
      })
      .store(in: &cancellables)
    
    // Then
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(mockRepository.postOrderCallsCount, 1, "Get function in repository should be called once")
  }
  
  func testGetProductFailure() {
    // Given
    mockRepository.postOrderReturnValue = Fail(error: NSError(domain: "MockError", code: 500, userInfo: nil)).eraseToAnyPublisher()

    // When
    let expectation = XCTestExpectation(description: "post order completes")
    useCase.execute(products: [ProductModel(name: "abc", price: 50.0, imageUrl: "image1")], address: "1/234")
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
    XCTAssertEqual(mockRepository.postOrderCallsCount, 1, "Post function in repository should be called once")
  }

}
