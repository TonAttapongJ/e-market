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
  
  // Inserting Row
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
  
  // Updating Row
  static func updateRow(_ productValues: ProductModel) -> Bool? {
    guard let database = SQLiteDatabase.sharedInstance.database else {
      print("Datastore connection error")
      return nil
    }
    
    // Extracts the appropriate contact from the table according to the id
    let contact = table.filter(id == productValues.id).limit(1)
    
    do {
      // Update the contact's values
      if try database.run(contact.update(name <- productValues.name, price <- productValues.price, quantity <- productValues.quantity, imageUrl <- productValues.imageUrl)) > 0 {
        print("Updated contact")
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
    
    // Contact Array
    var productArray = [ProductModel]()
    
    // Sorting data in descending order by ID
    table = table.order(id.desc)
    
    do {
      for product in try database.prepare(table) {
        
        let idValue = product[id]
        let nameValue = product[name]
        let priceValue = product[price]
        let quantityValue = product[quantity]
        let imageUrlValue = product[imageUrl]
        
        // Create object
        let productObject = ProductModel(id: idValue, name: nameValue, price: priceValue, imageUrl: imageUrlValue, quantity: quantityValue)
        
        // Add object to an array
        productArray.append(productObject)
      }
    } catch {
      print("Present row error: \(error)")
      return []
    }
    return productArray
  }
  
  // Delete Row
  static func deleteRow(productId: Int) {
    guard let database = SQLiteDatabase.sharedInstance.database else {
      print("Datastore connection error")
      return
    }
    
    do {
      let contact = table.filter(id == productId).limit(1)
      try database.run(contact.delete())
    } catch {
      print("Delete row error: \(error)")
    }
  }
}
