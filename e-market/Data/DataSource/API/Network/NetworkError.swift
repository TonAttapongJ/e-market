//
//  NetworkError.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
enum NetworkError: Error {
  case jsonDecodeFailed
  case badRequest
  case unauthorized
  case forbidden
  case notFound
  case serverError
  case cancelled
  case timeOut
  case networkConnectionLost
  case notConnectedToInternet
  case unknown

  var localizedDescription: String {
    switch self {
    case .jsonDecodeFailed: return "JSON Decode Dailed"
    case .badRequest: return "400 bad request"
    case .unauthorized: return "401 unauthorized"
    case .forbidden: return "403 forbidden"
    case .notFound: return "404 not found"
    case .serverError: return "500 server error"
    case .cancelled: return "Cancelled"
    case .timeOut: return "Timed out"
    case .networkConnectionLost: return "Network Connection Lost"
    case .notConnectedToInternet: return "Not Connected To Internet"
    case .unknown: return "unknow error"
    }
  }
}

