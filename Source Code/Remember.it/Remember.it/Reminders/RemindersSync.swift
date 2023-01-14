//
//  RemindersSync.swift
//  Remember.it
//
//  Created by Mark Howard on 13/01/2023.
//

import Foundation
import EventKit
import SwiftUI
import Combine

//Class And Functions To Create And Manage Reminders
class RemindersSync {
    //Init The Event Store
    let eventStore = EKEventStore()
    //Init Reminders List
    var remindersCalendar: EKCalendar? = nil
    //Array Of Reminders In List
    var reminders: [EKReminder] = []
    
    //Request Access To Reminders
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
    
    //Create Remember.it Reminders List
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
    
    //Fetch Reminders Into Array
    func fetchReminders() {
        guard let remindersCalendar = eventStore.defaultCalendarForNewReminders() else { return }
      
      let predicate = eventStore.predicateForReminders(in: [remindersCalendar])
      
      eventStore.fetchReminders(matching: predicate) { results in
        if let results = results {
          self.reminders = results
        }
      }
    }
    
    //Create Reminder
    func createReminder(title: String, priority: Int, notes: String, date: DateComponents) {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        reminder.notes = notes
        reminder.priority = priority
        reminder.dueDateComponents = date
        //reminder.calendar = remindersCalendar
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
    
        //Create A Completed Task
        //reminder.isCompleted = false
    
        //Set A Task Deadline
        //reminder.dueDateComponents = DateComponents()
    
        do {
            try eventStore.save(reminder, commit: true)
        } catch {
            print("Saving Reminder Failed With Error: \(error.localizedDescription)")
        }
    }
}
