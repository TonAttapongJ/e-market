//
//  DateFormatter.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation

extension String {
  func toDateWithFormat(format: String = "h a") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss.SSS'Z'"
    if let date = dateFormatter.date(from: self) {
        dateFormatter.dateFormat = format
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    return ""
  }
}
