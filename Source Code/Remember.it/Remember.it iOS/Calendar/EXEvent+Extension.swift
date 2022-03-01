//
//  EXEvent+Extension.swift
//  Remember.it
//
//  Created by Mark Howard on 06/02/2022.
//

import EventKit
import SwiftUI

extension EKEvent {
    var color: Color {
        return Color(UIColor(cgColor: self.calendar.cgColor))
    }
}
