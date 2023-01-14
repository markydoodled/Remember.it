//
//  SelectedCalendarList.swift
//  Remember.it
//
//  Created by Mark Howard on 13/01/2023.
//

import SwiftUI
import EventKit

//List Of All The Selected Calendars
struct SelectedCalendarsList: View {
    let selectedCalendars: [EKCalendar]
    var joinedText: Text {
        var text = Text("")
        for calendar in selectedCalendars {
            text = text + calendar.formattedText + Text("  ")
        }
        return text
    }
    var body: some View {
        joinedText.foregroundColor(.secondary)
    }
}
