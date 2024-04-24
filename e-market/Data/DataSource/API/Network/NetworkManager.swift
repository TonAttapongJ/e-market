//
//  NetworkManager.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Moya
import Combine
import CombineMoya

protocol NetworkManagerProtocol {
  func request<T: Decodable, Target: TargetType>(target: Target) -> Future<T, Error>
  func request<Target: TargetType>(target: Target) -> Future<Void, Error>
}

class NetworkManager: NetworkManagerProtocol {
  private let networkLoggerPlugin: NetworkLoggerPlugin
  private let networkPlugin: NetworkPlugin
  private var anyCancellable: Set<AnyCancellable> = .init()
  
  public init() {
    self.networkLoggerPlugin = NetworkLoggerPlugin()
    self.networkPlugin = NetworkPlugin()
  }
  
  public func request<T: Decodable, Target: TargetType>(target: Target) -> Future<T, Error> {
    return Future { [weak self] promise in
      guard let self = self else { return }
      let provider = MoyaProvider<Target>(plugins: [
        self.networkPlugin
      ])
      provider.requestPublisher(target)
        .sink(receiveCompletion: { completion in
          guard case let .failure(error) = completion else { return }
          if case let .underlying(nsError as NSError, response) = error {
            promise(.failure(self.networkError(error: nsError, response: response)))
          } else {
            promise(.failure(NetworkError.unknown))
          }
        }, receiveValue: { response in
          do {
            let results = try JSONDecoder().decode(T.self, from: response.data)
            promise(.success(results))
          } catch {
            promise(.failure(NetworkError.jsonDecodeFailed))
          }
        })
        .store(in: &self.anyCancellable)
    }
  }
  
  public func request<Target: TargetType>(target: Target) -> Future<Void, Error> {
    return Future { [weak self] promise in
      guard let self = self else { return }
      
      let provider = MoyaProvider<Target>(plugins: [
        self.networkPlugin
      ])
      provider.requestPublisher(target)
        .sink(receiveCompletion: { completion in
          guard case let .failure(error) = completion else { return }
          if case let .underlying(nsError as NSError, response) = error {
            promise(.failure(self.networkError(error: nsError, response: response)))
          } else {
            promise(.failure(NetworkError.unknown))
          }
        }, receiveValue: { response in
          promise(.success(()))
        })
        .store(in: &self.anyCancellable)
    }
  }
  
  func networkError(error: NSError, response: Moya.Response?) -> NetworkError {
    if let response = response {
      switch response.statusCode {
      case 400: return .badRequest
      case 401: return .unauthorized
      case 403: return .forbidden
      case 404: return .notFound
      case 500: return .serverError
      default: return NetworkError.unknown
      }
    } else {
      switch error.code {
      case NSURLErrorCancelled: return .cancelled
      case NSURLErrorTimedOut: return .timeOut
      case NSURLErrorNetworkConnectionLost: return .networkConnectionLost
      case NSURLErrorNotConnectedToInternet: return .notConnectedToInternet
      default: return NetworkError.unknown
      }
    }
  }
  
}
