//
//  RemindersSync.swift
//  Remember.it
//
//  Created by Mark Howard on 07/02/2022.
//

import Foundation
import EventKit
import SwiftUI
import Combine

class RemindersSync {
  let eventStore = EKEventStore()
  var remindersCalendar: EKCalendar? = nil
  var reminders: [EKReminder] = []
    
  func requestRemindersAccess(completion: @escaping (Bool) -> Void) {
    eventStore.requestAccess(to: .reminder) { (granted, error) in
      if let error = error {
        print("EKEventStore request access completed with error: \(error.localizedDescription)")
        completion(granted)
        return
      }
      completion(granted)
    }
  }
  
  func createRemindersCalendar() {
    let calendar = EKCalendar(for: .reminder, eventStore: eventStore)
    calendar.source = eventStore.defaultCalendarForNewReminders()?.source
    calendar.title = "Remember.it"
    calendar.cgColor = UIColor.systemYellow.cgColor
    
    do {
      try eventStore.saveCalendar(calendar, commit: true)
    } catch {
      print("Calendar creation failed with error: \(error.localizedDescription)")
      return
    }
    
    remindersCalendar = calendar
  }
  
  func fetchReminders() {
      guard let remindersCalendar = eventStore.defaultCalendarForNewReminders() else { return }
    
    let predicate = eventStore.predicateForReminders(in: [remindersCalendar])
    
    eventStore.fetchReminders(matching: predicate) { results in
      if let results = results {
        self.reminders = results
      }
    }
  }
  
    func createReminder(title: String, priority: Int, notes: String, date: DateComponents) {
    let reminder = EKReminder(eventStore: eventStore)
    reminder.title = title
    reminder.notes = notes
    reminder.priority = priority
    reminder.dueDateComponents = date
    //reminder.calendar = remindersCalendar
    reminder.calendar = eventStore.defaultCalendarForNewReminders()
    
    // You can create a completed task
    // reminder.isCompleted = false
    
    // You can set a task deadline
    // reminder.dueDateComponents = DateComponents()
    
    do {
      try eventStore.save(reminder, commit: true)
    } catch {
      print("Saving reminder failed with error: \(error.localizedDescription)")
    }
  }
}
