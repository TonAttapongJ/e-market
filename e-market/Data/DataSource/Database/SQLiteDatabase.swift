//
//  SQLiteDatabase.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation
import SQLite

class SQLiteDatabase {
  static let sharedInstance = SQLiteDatabase()
  var database: Connection?
  
  private init() {
    do {
      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      let fileUrl = documentDirectory.appendingPathComponent("productList").appendingPathExtension("sqlite3")
      print("SQLite fileURL: \(fileUrl)")
      database = try Connection(fileUrl.path)
    } catch {
      print("Creating connection to database error: \(error)")
    }
  }
  func createTable() {
    SQLiteCommands.createTable()
  }
}
