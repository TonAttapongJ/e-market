//
//  GetStoreUseCaseTest.swift
//  e-marketTests
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import XCTest
import Combine
@testable import e_market

final class GetStoreUseCaseTest: XCTestCase {
  var cancellables = Set<AnyCancellable>()
  var mockRepository: MockStoreRepository!
  var useCase: GetStoreUseCase!

  override func setUp() {
    super.setUp()
    mockRepository = MockStoreRepository()
    useCase = GetStoreUseCaseImpl(repository: mockRepository)
  }
  
  override func tearDown() {
    mockRepository = nil
    useCase = nil
    cancellables = []
    super.tearDown()
  }

  func testGetProductSuccess() {
    // Given
    let storeResponse = StoreResponse(name: "ABC", rating: 4.5, openingTime: "3PM", closingTime: "7PM")
    mockRepository.getStoreInformationReturnValue = Just((storeResponse)).setFailureType(to: Error.self).eraseToAnyPublisher()
    
    // When
    let expectation = XCTestExpectation(description: "Get store completes")
    useCase.execute()
      .sink(receiveCompletion: { _ in
        expectation.fulfill()
      }, receiveValue: { (value) in
        let expectedModel: StoreModel = StoreModel(
          name: storeResponse.name,
          rating: storeResponse.rating,
          openingTime: storeResponse.openingTime,
          closingTime: storeResponse.closingTime
        )
        XCTAssertEqual(value, expectedModel, "Mock store should be equal")
      })
      .store(in: &cancellables)
    
    // Then
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(mockRepository.getStoreCallsCount, 1, "Get function in repository should be called once")
  }
  
  func testGetProductFailure() {
    // Given
    mockRepository.getStoreInformationReturnValue = Fail(error: NSError(domain: "MockError", code: 500, userInfo: nil)).eraseToAnyPublisher()

    // When
    let expectation = XCTestExpectation(description: "Get store completes")
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
    XCTAssertEqual(mockRepository.getStoreCallsCount, 1, "Get function in repository should be called once")
  }

}
