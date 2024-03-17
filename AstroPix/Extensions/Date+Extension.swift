//
//  Date+Extension.swift
//  AstroPix
//
//  Created by Martin Šimar on 17.03.2024.
//

import Foundation

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func withoutTime() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        
        if let today = calendar.date(from: dateComponents) {
            return today
        } else {
            print("Error setting date without time")
            return Date()
        }
    }
    
    func yesterday() -> Date {
        let timeInterval: TimeInterval = -24 * 60 * 60
        return self.addingTimeInterval(timeInterval)
    }
    
    func tomorrow() -> Date {
        let timeInterval: TimeInterval = 24 * 60 * 60
        return self.addingTimeInterval(timeInterval)
    }
}
