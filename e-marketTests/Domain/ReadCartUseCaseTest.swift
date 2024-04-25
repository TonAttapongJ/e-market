//
//  ReadCartUseCaseTest.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import XCTest
import Combine
@testable import e_market

final class ReadCartUseCaseTest: XCTestCase {
  var cancellables = Set<AnyCancellable>()
  var mockRepository: MockCartRepository!
  var useCase: ReadCartUseCase!
  
  override func setUp() {
    super.setUp()
    mockRepository = MockCartRepository()
    useCase = ReadCartUseCaseImpl(respository: mockRepository)
  }
  
  override func tearDown() {
    mockRepository = nil
    useCase = nil
    cancellables = []
    super.tearDown()
  }
  
  func testReadCartSuccess() {
    // Given
    let products = [
      ProductModel(id: 1, name: "Test Product 1", price: 50.0, imageUrl: "testImage1", quantity: 2),
      ProductModel(id: 2, name: "Test Product 2", price: 75.0, imageUrl: "testImage2", quantity: 3)
    ]
    mockRepository.readReturnValue = Just(products).setFailureType(to: Error.self).eraseToAnyPublisher()
    
    // When
    let expectation = XCTestExpectation(description: "Read cart completes")
    useCase.execute()
      .sink(receiveCompletion: { _ in
        expectation.fulfill()
      }, receiveValue: { receivedProducts in
        XCTAssertEqual(receivedProducts, products, "Received products should match expected products")
      })
      .store(in: &cancellables)
    
    // Then
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(mockRepository.readCallsCount, 1, "Read function in repository should be called once")
  }
  
  func testReadCartEmpty() {
    // Given
    mockRepository.readReturnValue = Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    
    // When
    let expectation = XCTestExpectation(description: "Read cart completes")
    useCase.execute()
      .sink(receiveCompletion: { _ in
        expectation.fulfill()
      }, receiveValue: { receivedProducts in
        XCTAssertTrue(receivedProducts.isEmpty, "Received products should be empty")
      })
      .store(in: &cancellables)
    
    // Then
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(mockRepository.readCallsCount, 1, "Read function in repository should be called once")
  }
  
  func testReadCartFailure() {
    // Given
    mockRepository.readReturnValue = Fail(error: NSError(domain: "MockError", code: 500, userInfo: nil)).eraseToAnyPublisher()
    
    // When
    let expectation = XCTestExpectation(description: "Read cart completes")
    useCase.execute()
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          let expectedError = NSError(domain: "MockError", code: 500, userInfo: nil)
          XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
          expectation.fulfill()
        }
      }, receiveValue: { _ in })
      .store(in: &cancellables)
    
    // Then
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(mockRepository.readCallsCount, 1, "Read function in repository should be called once")
  }
}
