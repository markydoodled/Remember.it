//
//  EKEvent+Extension.swift
//  Remember.it
//
//  Created by Mark Howard on 13/01/2023.
//

import SwiftUI
import EventKit

//Calendar Event Colours
extension EKEvent {
    var color: Color {
        return Color(UIColor(cgColor: self.calendar.cgColor))
    }
}
