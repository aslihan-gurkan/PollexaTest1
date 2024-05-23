//
//  DateHelper.swift
//  PollexaTest1
//
//  Created by Aslıhan Gürkan on 23.05.2024.
//

import Foundation

class DateHelper {
    static func calculateDateRemainder(from date: Date, isVote: Bool) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: currentDate)
        
        let timeUnits = [
            ("year", components.year),
            ("month", components.month),
            ("day", components.day),
            ("hour", components.hour),
            ("minute", components.minute),
            ("second", components.second)
        ]
        
        for (unit, value) in timeUnits {
            if let value = value, value > 0 {
                let unitString = value == 1 ? unit : unit + "s"
                let agoString = isVote ? " AGO" : " ago"
                
                let formattedValue = "\(value) \(unitString)"
                return isVote ? formattedValue.uppercased() + agoString.uppercased() : formattedValue.lowercased() + agoString
            }
        }
        
        return isVote ? "JUST NOW" : "just now"
    }
}

/*
//TODO:
 
class DateeHelper {
    static func calculateDateRemainder<T: Comparable>(from date: T, to currentDate: T) -> String where T: Strideable {
        guard let date = date as? Date, let currentDate = currentDate as? Date else {
            return "Invalid date"
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: currentDate)
        
        let timeUnits = [
            ("year", components.year),
            ("month", components.month),
            ("day", components.day),
            ("hour", components.hour),
            ("minute", components.minute),
            ("second", components.second)
        ]
        
        for (unit, value) in timeUnits {
            if let value = value, value > 0 {
                return value == 1 ? "1 \(unit) ago" : "\(value) \(unit)s ago"
            }
        }
        
        return "just now"
    }
}
*/
