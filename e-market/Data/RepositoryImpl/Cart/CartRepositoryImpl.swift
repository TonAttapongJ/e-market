//
//  AddToCartRepositoryImpl.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import SQLite
import Combine

class CartRepositoryImpl: CartRepository {
  let databaseManager: SQLiteDatabase

  init(databaseManager: SQLiteDatabase = SQLiteDatabase.sharedInstance) {
    self.databaseManager = databaseManager
  }
  
  func create(product: ProductModel, quantity: Int) -> AnyPublisher<Void, any Error> {
    SQLiteDatabase.sharedInstance.createTable()
    var productToAdded = product
    productToAdded.quantity = quantity
    let productAddedToTable = SQLiteCommands.insertRow(productToAdded)
    if productAddedToTable == true {
      return Empty<Void, Error>().eraseToAnyPublisher()
    } else {
      return Fail(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not insert to DB"])).eraseToAnyPublisher()
    }
  }
  
  func read() -> AnyPublisher<[ProductModel], any Error> {
    let productArray = SQLiteCommands.presentRows() ?? []
    return Just(productArray).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
}
