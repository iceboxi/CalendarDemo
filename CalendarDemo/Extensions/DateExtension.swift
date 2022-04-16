//
//  DateExtension.swift
//  CalendarDemo
//
//  Created by ice on 2022/4/16.
//

import Foundation

extension Date {
    public func stringFormat(_ format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    public func dateByAddSeconds(_ seconds: Int) -> Date {
        return self.dateByAdd({ comps -> Void in
            comps.second = seconds
        })
    }
    
    public func dateByAddDays(_ days: Int) -> Date {
        return self.dateByAdd({ comps -> Void in
            comps.day = days
        })
    }
    
    fileprivate func dateByAdd(_ processing:  (_ comps: inout DateComponents) -> Void) -> Date {
        var comps = DateComponents()
        
        processing(&comps)
        
        return (Calendar.current as NSCalendar).date(byAdding: comps, to: self, options: NSCalendar.Options(rawValue: 0)) ?? Date()

    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}
