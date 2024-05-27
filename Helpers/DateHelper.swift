//
//  DateHelper.swift
//  PollexaTest1
//
//  Created by Aslıhan Gürkan on 23.05.2024.
//

import Foundation
   
class DateHelper {
    
    static let localizedUpperAGOContent = NSLocalizedString("upperAGO", comment: "")
    static let localizedLowerAGOContent = NSLocalizedString("lowerAGO", comment: "")
    static let localizedJustNow = NSLocalizedString("justNow", comment: "")
    static let localizedJustNowUppercase = NSLocalizedString("JUST_NOW", comment: "")
    
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
                let localizedUnitSingular = NSLocalizedString(unit, comment: "")
                let localizedUnitPlural = NSLocalizedString("\(unit)s", comment: "")
                
                let unitString = value == 1 ? localizedUnitSingular : localizedUnitPlural
                let agoString = isVote ? " \(localizedUpperAGOContent)" : " \(localizedLowerAGOContent)"
                
                let formattedValue = "\(value) \(unitString)"
                return isVote ? formattedValue.uppercased() + agoString.uppercased() : formattedValue.lowercased() + agoString
            }
        }
        
        return isVote ? localizedJustNowUppercase : localizedJustNow
    }
    
    static func localeControl() -> Bool {
        
        let currentLocale = Locale.current
        let isEnglish = currentLocale.language.languageCode?.identifier == "en"
        return isEnglish
    }
}
