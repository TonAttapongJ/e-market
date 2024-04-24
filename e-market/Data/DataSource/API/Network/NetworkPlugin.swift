//
//  NetworkPlugin.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import Combine
import Moya
import CombineMoya

public struct NetworkPlugin: PluginType {
  public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }
  
  public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    debugPrint("NetworkPlugin didReceive result: \(result)")
    debugPrint("NetworkPlugin didReceive target: \(target)")
  }
  
  public func willSend(_ request: RequestType, target: TargetType) {
    debugPrint("NetworkPlugin willSend request: \(request)")
    debugPrint("NetworkPlugin willSend target: \(target)")
  }
}

