//
//  TimeInterval+Extension.swift
//  Remember.it
//
//  Created by Mark Howard on 13/01/2023.
//

import Foundation

//Generate Week To Get Calendar Events
extension TimeInterval {
    static func weeks(_ weeks: Double) -> TimeInterval {
        return weeks * TimeInterval.week
    }
    
    static var week: TimeInterval {
        return 7 * 24 * 60 * 60
    }
}
