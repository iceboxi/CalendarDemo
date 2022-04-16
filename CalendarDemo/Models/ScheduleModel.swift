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
