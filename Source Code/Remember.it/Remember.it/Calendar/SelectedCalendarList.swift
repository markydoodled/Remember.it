//
//  SelectedCalendarList.swift
//  Remember.it
//
//  Created by Mark Howard on 06/02/2022.
//

import EventKit
import SwiftUI

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

