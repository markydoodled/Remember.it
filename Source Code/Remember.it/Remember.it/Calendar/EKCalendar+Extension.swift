//
//  EKCalendar+Extension.swift
//  Remember.it
//
//  Created by Mark Howard on 13/01/2023.
//

import SwiftUI
import EventKit

//Calendar Title To Iterate Selected
extension EKCalendar: Identifiable {
    public var id: String {
        return self.calendarIdentifier
    }
    
    public var color: Color {
        return Color(UIColor(cgColor: self.cgColor))
    }
    
    //Calendar Name And Colour Dot
    public var formattedText: Text {
        return Text("•\u{00a0}")
            .font(.headline)
            .foregroundColor(self.color)
            + Text("\(self.title)")
    }
}
