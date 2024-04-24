//
//  StoreAPI.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Moya

struct StoreAPI: TargetType {
  let baseURL: URL = CoreConstants.baseUrl
  let path: String
  var method: Moya.Method
  var task: Task
  var headers: [String : String]?
  let validationType: ValidationType = .successAndRedirectCodes
  var authorizationType: AuthorizationType? = nil
  
  static func getStoreInformation() -> StoreAPI {
    return .init(
      path: "/storeInfo",
      method: .get,
      task: .requestPlain,
      authorizationType: nil)
  }
}
