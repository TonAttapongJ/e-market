//
//  SQLiteCommands.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import SQLite

class SQLiteCommands {
  
  static var table = Table("cart")
  static let id = Expression<Int>("id")
  static let name = Expression<String>("name")
  static let price = Expression<Double>("price")
  static let quantity = Expression<Int>("quantity")
  static let imageUrl = Expression<String>("imageUrl")
  
  static func createTable() {
    guard let database = SQLiteDatabase.sharedInstance.database else {
      print("Datastore connection error")
      return
    }
    
    do {
      try database.run(table.create(ifNotExists: true) { table in
        table.column(id, primaryKey: true)
        table.column(name)
        table.column(price)
        table.column(quantity)
        table.column(imageUrl)
      })
    } catch {
      print("Table already exists: \(error)")
    }
  }
  
  static func insertRow(_ productValues: ProductModel) -> Bool? {
    guard let database = SQLiteDatabase.sharedInstance.database else {
      print("Datastore connection error")
      return nil
    }
    
    do {
      try database.run(table.insert(name <- productValues.name, price <- productValues.price, quantity <- productValues.quantity, imageUrl <- productValues.imageUrl))
      return true
    } catch {
      return false
    }
  }
  
  static func updateRow(_ productValues: ProductModel) -> Bool? {
    guard let database = SQLiteDatabase.sharedInstance.database else {
      print("Datastore connection error")
      return nil
    }
    
    let contact = table.filter(id == productValues.id).limit(1)
    
    do {
      if try database.run(contact.update(name <- productValues.name, price <- productValues.price, quantity <- productValues.quantity, imageUrl <- productValues.imageUrl)) > 0 {
        return true
      } else {
        print("Could not update contact: contact not found")
        return false
      }
    } catch {
      return false
    }
  }
  
  // Present Rows
  static func presentRows() -> [ProductModel]? {
    guard let database = SQLiteDatabase.sharedInstance.database else {
      print("Datastore connection error")
      return nil
    }
    
    var productArray = [ProductModel]()
    
    table = table.order(id.desc)
    
    do {
      for product in try database.prepare(table) {
        
        let idValue = product[id]
        let nameValue = product[name]
        let priceValue = product[price]
        let quantityValue = product[quantity]
        let imageUrlValue = product[imageUrl]
        
        let productObject = ProductModel(id: idValue, name: nameValue, price: priceValue, imageUrl: imageUrlValue, quantity: quantityValue)
        
        productArray.append(productObject)
      }
    } catch {
      print("Present row error: \(error)")
      return []
    }
    return productArray
  }
  
  static func deleteRow(productId: Int) -> Bool? {
    guard let database = SQLiteDatabase.sharedInstance.database else {
      print("Datastore connection error")
      return nil
    }
    
    do {
      let contact = table.filter(id == productId).limit(1)
      try database.run(contact.delete())
      return true
    } catch {
      print("Delete row error: \(error)")
      return false
    }
  }
}
