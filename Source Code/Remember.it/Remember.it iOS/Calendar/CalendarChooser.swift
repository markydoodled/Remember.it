//
//  CalendarChooser.swift
//  Remember.it
//
//  Created by Mark Howard on 06/02/2022.
//

import SwiftUI
import EventKitUI

struct CalendarChooser: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var calendars: Set<EKCalendar>?
    
    let eventStore: EKEventStore
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CalendarChooser>) -> UINavigationController {
        let chooser = EKCalendarChooser(selectionStyle: .multiple, displayStyle: .allCalendars, entityType: .event, eventStore: eventStore)
        chooser.selectedCalendars = calendars ?? []
        chooser.delegate = context.coordinator
        chooser.showsDoneButton = true
        chooser.showsCancelButton = true
        return UINavigationController(rootViewController: chooser)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<CalendarChooser>) {
        
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, EKCalendarChooserDelegate {
        let parent: CalendarChooser
        
        init(_ parent: CalendarChooser) {
            self.parent = parent
        }
        
        func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
            parent.calendars = calendarChooser.selectedCalendars
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

