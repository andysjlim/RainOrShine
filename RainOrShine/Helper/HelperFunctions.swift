//
//  HelperFunctions.swift
//  RainOrShine
//
//  Created by Andy Lim on 9/9/21.
//  Copyright © 2021 Andy Lim. All rights reserved.
//

import UIKit

extension Date {
    
    static func getTodaysDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
    
    static func getHourFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        var string = dateFormatter.string(from: date)
        if string.last == "M" {
            string = String(string.prefix(string.count-3))
        }
        
        return string
    }
    
    static func getDayOfWeekFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        var string = dateFormatter.string(from: date)
        if let index = string.firstIndex(of: ",") {
            string = String(string.prefix(upTo: index))
            return string
        }
        
        return "error"
    }
    
    static func dayNameOfWeek() -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: Date())
    }
}
