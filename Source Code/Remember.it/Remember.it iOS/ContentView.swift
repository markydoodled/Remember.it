//
//  ContentView.swift
//  Remember.it
//
//  Created by Mark Howard on 01/02/2022.
//

import SwiftUI
import EventKit
import Combine
import MessageUI

struct ContentView: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    enum ActiveSheet {
        case calendarChooser
        case calendarEdit
    }
    @State private var showingSheet = false
    @State private var activeSheet: ActiveSheet = .calendarChooser
    @ObservedObject var eventsRepository = EventsRepository.shared
    @State private var selectedEvent: EKEvent?
    func showEditFor(_ event: EKEvent) {
        activeSheet = .calendarEdit
        selectedEvent = event
        showingSheet = true
    }
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var tabSelection = 1
    @State var showingSettings = false
    @State var reminderName = ""
    @State var reminderPriority = 0
    @State var reminderNotes = ""
    @State var reminderDate = Date()
    var settings: some View {
        Form {
            HStack {
                Text("Version")
                Spacer()
                Text("1.1")
            }
            HStack {
                Text("Build")
                Spacer()
                Text("2")
            }
            HStack {
                Text("Feedback: ")
                Spacer()
                Button(action: {self.isShowingMailView.toggle()}) {
                    Text("Send Some Feedback")
                }
                .sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: self.$isShowingMailView, result: self.$result)
                }
            }
        }
    }
    var reminders: some View {
        Form {
            TextField("Name...", text: $reminderName)
            TextField("Notes...", text: $reminderNotes)
            HStack {
                Picker("Priority", selection: $reminderPriority) {
                    Text("None")
                        .tag(0)
                    Text("Low")
                        .tag(1)
                    Text("Medium")
                        .tag(2)
                    Text("High")
                        .tag(3)
                }
            }
            DatePicker("Due Date", selection: $reminderDate, displayedComponents: .date)
        }
        .navigationTitle("New Reminder")
        .task {
            RemindersSync().requestRemindersAccess { result in
                if result == true {
                print("success")
                } else {
                    print("error")
                }
            }
            RemindersSync().fetchReminders()
        }
    .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                let val = 0
                let nextTriggerDate = Calendar.current.date(byAdding: .day, value: val, to: reminderDate)!
                let comps = Calendar.current.dateComponents([.year, .month, .day], from: nextTriggerDate)

                RemindersSync().createReminder(title: reminderName, priority: reminderPriority, notes: reminderNotes, date: comps)
            }) {
                Text("Done")
            }
        }
    }
    }
    var calendar: some View {
            VStack {
                List {
                    if eventsRepository.events?.isEmpty ?? true {
                        Text("No Events Available For This Calendar Selection")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    ForEach(eventsRepository.events ?? [], id: \.self) { event in
                        EventRow(event: event).onTapGesture {
                            self.showEditFor(event)
                        }
                    }
                }
                SelectedCalendarsList(selectedCalendars: Array(eventsRepository.selectedCalendars ?? []))
                    .padding(.vertical)
                    .padding(.horizontal, 5)
                
                Button(action: {
                    self.activeSheet = .calendarChooser
                    self.showingSheet = true
                }) {
                    Text("Select Calendars")
                }
                .buttonStyle(PrimaryButtonStyle())
                .sheet(isPresented: $showingSheet) {
                    if self.activeSheet == .calendarChooser {
                        CalendarChooser(calendars: self.$eventsRepository.selectedCalendars, eventStore: self.eventsRepository.eventStore)
                    } else {
                        EventEditView(eventStore: self.eventsRepository.eventStore, event: self.selectedEvent)
                    }
                }
                .padding(.bottom)
            }
            .navigationBarTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.selectedEvent = nil
                        self.activeSheet = .calendarEdit
                        self.showingSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
    }
    var body: some View {
        if horizontalSizeClass == .compact {
            TabView(selection: $tabSelection) {
                NavigationView {
                    calendar
                }
                .tag(1)
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                }
                NavigationView {
                    reminders
                }
                .tag(2)
                .tabItem {
                    VStack {
                        Image(systemName: "checklist")
                        Text("Reminders")
                    }
                }
                NavigationView {
                    settings
                        .navigationTitle("Settings")
                }
                .tag(3)
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                }
            }
        } else {
         NavigationView {
             List {
                 NavigationLink(destination: calendar) {
                     Label("Calendar", systemImage: "calendar")
                 }
                 NavigationLink(destination: reminders) {
                     Label("Reminders", systemImage: "checklist")
                 }
             }
             .listStyle(SidebarListStyle())
             .navigationTitle("Remember.it")
             .toolbar {
                 ToolbarItem(placement: .navigationBarTrailing) {
                     Button(action: {self.showingSettings = true}) {
                         Image(systemName: "gearshape")
                     }
                     .sheet(isPresented: $showingSettings) {
                         NavigationView {
                             settings
                                 .navigationTitle("Settings")
                                 .toolbar {
                                     ToolbarItem(placement: .navigationBarTrailing) {
                                         Button(action: {self.showingSettings = false}) {
                                             Text("Done")
                                         }
                                     }
                                 }
                         }
                     }
                 }
             }
             List {
                 Text("Please Choose A Function...")
             }
             .navigationTitle("Choose")
             VStack {
                 Image("AppsIcon")
                     .resizable()
                     .cornerRadius(25)
                     .frame(width: 150, height: 150)
                 Text("Remember.it")
                     .font(.title2)
                     .bold()
                     .padding()
             }
         }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MailView: UIViewControllerRepresentable {

    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
