//
//  GetProductUseCaseTest.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import XCTest
import Combine
@testable import e_market

final class GetProductUseCaseTest: XCTestCase {
  var cancellables = Set<AnyCancellable>()
  var mockProductRepository: MockProductRepository!
  var useCase: GetProductUseCase!

  override func setUp() {
    super.setUp()
    mockProductRepository = MockProductRepository()
    useCase = GetProductUseCaseImpl(repository: mockProductRepository)
  }
  
  override func tearDown() {
    mockProductRepository = nil
    useCase = nil
    cancellables = []
    super.tearDown()
  }

  func testGetProductSuccess() {
    // Given
    let productResponse = [ProductResponse(name: "Test Product", price: 50.0, imageUrl: "testImage")]
    mockProductRepository.getProductsReturnValue = Just((productResponse)).setFailureType(to: Error.self).eraseToAnyPublisher()
    
    // When
    let expectation = XCTestExpectation(description: "Get product completes")
    useCase.execute()
      .sink(receiveCompletion: { _ in
        expectation.fulfill()
      }, receiveValue: { (value) in
        let expectedModel: [ProductModel] = productResponse.map { ProductModel(
          name: $0.name,
          price: $0.price,
          imageUrl: $0.imageUrl)}
        XCTAssertEqual(value, expectedModel, "Mock Product should be equal")
      })
      .store(in: &cancellables)
    
    // Then
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(mockProductRepository.getProductCallsCount, 1, "Get function in repository should be called once")
  }
  
  func testGetProductFailure() {
    // Given
    mockProductRepository.getProductsReturnValue = Fail(error: NSError(domain: "MockError", code: 500, userInfo: nil)).eraseToAnyPublisher()

    // When
    let expectation = XCTestExpectation(description: "Get product completes")
    useCase.execute()
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
    XCTAssertEqual(mockProductRepository.getProductCallsCount, 1, "Get function in repository should be called once")
  }

}
