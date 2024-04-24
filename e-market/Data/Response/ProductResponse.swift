//
//  ProductResponse.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation

struct ProductResponse: Codable {
  let name: String
  let price: Double
  let imageUrl: String

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.price = try container.decode(Double.self, forKey: .price)
    self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
  }
}
