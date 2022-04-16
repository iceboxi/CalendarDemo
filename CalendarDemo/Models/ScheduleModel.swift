//
//  ScheduleModel.swift
//  CalendarDemo
//
//  Created by ice on 2022/4/16.
//

import Foundation
import ObjectMapper

struct Schedule: Mappable {
    var available: [TimeRange]
    var booked: [TimeRange]

    init?(map: Map) {
        available = []
        booked = []
    }
    
    mutating func mapping(map: Map) {
        available <- map["available"]
        booked <- map["booked"]
    }
    
    func expandSchedule() -> [String: [Lecture]] {
        func generateKey(with date: Date) -> String? {
            if isTooLate(date) {
                return nil
            }
            
            return date.stringFormat("yyyy/MM/dd")
        }
        
        func isTooLate(_ date: Date) -> Bool {
            return date < Date().startOfDay
        }
        
        func nextStep(_ date: inout Date) {
            date = date.dateByAddSeconds(60*30)
        }
        
        func saveLectureSchedule(_ result: inout [String: [Lecture]], lesson: TimeRange, booked: Bool) {
            var temp = lesson.start
            while temp < lesson.end {
                if let key = generateKey(with: temp) {
                    var value: [Lecture] = result[key] ?? []
                    value.append(Lecture(start: temp, booked: booked))
                    result[key] = value
                }
                nextStep(&temp)
            }
        }
        
        func sortSchedule(_ result: inout [String: [Lecture]]) {
            for key in result.keys {
                let value = result[key]
                result[key] = value?.sorted(by: { $0.start < $1.start })
            }
        }
        
        var result = [String: [Lecture]]()
        for lesson in available {
            saveLectureSchedule(&result, lesson: lesson, booked: false)
        }
        
        for book in booked {
            saveLectureSchedule(&result, lesson: book, booked: true)
        }
        
        sortSchedule(&result)
        
        return result
    }
}

struct TimeRange: Mappable {
    var start: Date
    var end: Date
    
    init?(map: Map) {
        start = Date()
        end = Date()
    }
    
    mutating func mapping(map: Map) {
        start <- (map["start"], ISO8601DateTransform())
        end <- (map["end"], ISO8601DateTransform())
    }
}

struct Lecture {
    var start: Date
    var booked: Bool
}
