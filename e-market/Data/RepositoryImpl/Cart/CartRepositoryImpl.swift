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
    databaseManager.createTable()
    var productToAdded = product
    productToAdded.quantity = quantity
    let productArray = SQLiteCommands.presentRows() ?? []
    let productExist = productArray.first(where: {$0.name == product.name})
    if let productExist = productExist {
      return update(product: product, quantity: quantity + productExist.quantity, productExist: productExist)
    } else {
      let productAddedToTable = SQLiteCommands.insertRow(productToAdded)
      if productAddedToTable == true {
        return Empty<Void, Error>().eraseToAnyPublisher()
      } else {
        return dbError(message: "Could not insert to DB").eraseToAnyPublisher()
      }
    }
  }
  
  func read() -> AnyPublisher<[ProductModel], any Error> {
    let productArray = SQLiteCommands.presentRows() ?? []
    return Just(productArray).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
  
  func update(product: ProductModel, quantity: Int) -> AnyPublisher<Void, any Error> {
    let productArray = SQLiteCommands.presentRows() ?? []
    let productExist = productArray.first(where: {$0.name == product.name})
    if quantity == 0 {
      return delete(product: product)
    } else {
      return update(product: product, quantity: quantity, productExist: productExist)
    }
  }

  func update(product: ProductModel, quantity: Int, productExist: ProductModel?) -> AnyPublisher<Void, any Error> {
    if let productExist = productExist {
      var newProduct = productExist
      newProduct.quantity = quantity
      let productUpdatedToTable = SQLiteCommands.updateRow(newProduct)
      if productUpdatedToTable == true {
        return Empty<Void, Error>().eraseToAnyPublisher()
      } else {
        return dbError(message: "Could not update to DB").eraseToAnyPublisher()
      }
    } else {
      return dbError(message: "Product is not exist").eraseToAnyPublisher()
    }
  }
  
  func delete(product: ProductModel) -> AnyPublisher<Void, any Error> {
    let productDeleteToTable = SQLiteCommands.deleteRow(productId: product.id)
    if productDeleteToTable == true {
      return Empty<Void, Error>().eraseToAnyPublisher()
    } else {
      return dbError(message: "Could not delete from DB").eraseToAnyPublisher()
    }
  }
  
  func dbError(message: String) -> Fail<Void, Error> {
    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    return Fail<Void, Error>(error: error)
  }

}
