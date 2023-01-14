//
//  TimeInterval+Extension.swift
//  Remember.it
//
//  Created by Mark Howard on 06/02/2022.
//

import Foundation

extension TimeInterval {
    static func weeks(_ weeks: Double) -> TimeInterval {
        return weeks * TimeInterval.week
    }
    
    static var week: TimeInterval {
        return 7 * 24 * 60 * 60
    }
}
