//
//  OrderAPI.swift
//  e-market
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import Foundation
import Moya

struct OrderAPI: TargetType {
  let baseURL: URL = CoreConstants.baseUrl
  let path: String
  var method: Moya.Method
  var task: Task
  var headers: [String : String]?
  let validationType: ValidationType = .successAndRedirectCodes
  var authorizationType: AuthorizationType? = nil
  
  static func postOrder(orderRequest: OrderRequest) -> OrderAPI {
    return .init(
      path: "/order",
      method: .post,
      task: .requestJSONEncodable(orderRequest),
      authorizationType: nil)
  }
}
