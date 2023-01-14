//
//  EKCalendar+Extension.swift
//  Remember.it
//
//  Created by Mark Howard on 06/02/2022.
//

import SwiftUI
import EventKit

extension EKCalendar: Identifiable {
    public var id: String {
        return self.calendarIdentifier
    }
    
    public var color: Color {
        return Color(UIColor(cgColor: self.cgColor))
    }
    
    public var formattedText: Text {
        return Text("•\u{00a0}")
            .font(.headline)
            .foregroundColor(self.color)
            + Text("\(self.title)")
    }
}
