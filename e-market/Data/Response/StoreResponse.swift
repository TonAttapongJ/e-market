//
//  StoreResponse.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation

struct StoreResponse: Codable {
  let name: String
  let rating: Double
  let openingTime: String
  let closingTime: String

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.rating = try container.decode(Double.self, forKey: .rating)
    self.openingTime = try container.decode(String.self, forKey: .openingTime)
    self.closingTime = try container.decode(String.self, forKey: .closingTime)
  }
}
