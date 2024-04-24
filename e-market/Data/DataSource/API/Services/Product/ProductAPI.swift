//
//  ProductAPI.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Moya

struct ProductAPI: TargetType {
  let baseURL: URL = CoreConstants.baseUrl
  let path: String
  var method: Moya.Method
  var task: Task
  var headers: [String : String]?
  let validationType: ValidationType = .successAndRedirectCodes
  var authorizationType: AuthorizationType? = nil
  
  static func getProducts() -> ProductAPI {
    return .init(
      path: "/products",
      method: .get,
      task: .requestPlain,
      authorizationType: nil)
  }
}
