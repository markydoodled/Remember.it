//
//  ContentView.swift
//  Remember.it
//
//  Created by Mark Howard on 08/01/2023.
//

import SwiftUI
import EventKit
import Combine
import MessageUI

//Main Home View
struct ContentView: View {
    //Composed Email Results Variable
    @State var result: Result<MFMailComposeResult, Error>? = nil
    //Is Showing Email View
    @State var isShowingMailView = false
    //Should Displayed Sheet Be Calendar Chooser Or Event Editor
    enum ActiveSheet {
        case calendarChooser
        case calendarEdit
    }
    //Is Sheet Object Shown
    @State private var showingSheet = false
    //Which Sheet Is Set To Active
    @State private var activeSheet: ActiveSheet = .calendarChooser
    //Init Where Events Are Stored
    @ObservedObject var eventsRepository = EventsRepository.shared
    //Which Event Is Selected
    @State private var selectedEvent: EKEvent?
    //Function To Show Edit View
    func showEditFor(_ event: EKEvent) {
        activeSheet = .calendarEdit
        selectedEvent = event
        showingSheet = true
    }
    //Detect Screen Horizontal Width Size For UI Resizing
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    //Which Tab Is Selected
    @State var tabSelection = 1
    //Is Showing Settings View
    @State var showingSettings = false
    //Init Reminder Name
    @State var reminderName = ""
    //Init Reminder Priority
    @State var reminderPriority = 0
    //Init Reminder Notes
    @State var reminderNotes = ""
    //Init Reminder Due Date
    @State var reminderDate = Date()
    //Init Disable New Reminder Button If No Title
    @State var newReminderDisabled = true
    var body: some View {
        if horizontalSizeClass == .compact {
            TabView(selection: $tabSelection) {
                //Calendar Tab
                NavigationStack {
                    calendar
                }
                .tag(1)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                //New Reminders Tab
                NavigationStack {
                    reminders
                }
                .tag(2)
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Reminders")
                }
                //Settings Tab
                NavigationStack {
                    settings
                        .navigationTitle("Settings")
                }
                .tag(3)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            }
        } else {
            NavigationSplitView {
                //Sidebar List
                List {
                    //Link To Calendar View
                    NavigationLink(destination: calendar) {
                        Label("Calendar", systemImage: "calendar")
                    }
                    //Link To Reminders View
                    NavigationLink(destination: reminders) {
                        Label("Reminders", systemImage: "checklist")
                    }
                }
                .listStyle(.sidebar)
                .navigationTitle("Remember.it")
                .toolbar {
                    //Toolbar Button To View Settings
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {self.showingSettings = true}) {
                            Image(systemName: "gearshape")
                        }
                        .sheet(isPresented: $showingSettings) {
                            NavigationStack {
                                settings
                                    .navigationTitle("Settings")
                                    .toolbar {
                                        //Dismiss Settings Button
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
            } content: {
                //Rest Of The Detail View Without A Selected Function
                List {
                    Text("Please Choose A Function...")
                }
                .listStyle(.plain)
                .navigationTitle("Choose")
            } detail: {
                VStack {
                    Image("AppsIcon")
                        .resizable()
                        .cornerRadius(25)
                        .frame(width: 150, height: 150)
                    Text("Remember.it")
                        .bold()
                        .font(.title2)
                        .padding()
                }
            }
        }
    }
    //Settings View
    var settings: some View {
        List {
            //Text For Version Number
            HStack {
                Text("Version")
                Spacer()
                Text("2.0")
            }
            //Text For Build Number
            HStack {
                Text("Build")
                Spacer()
                Text("1")
            }
            //Button To Send Feedback
            Button(action: {self.isShowingMailView.toggle()}) {
                Text("Send Some Feedback")
                    .foregroundColor(.accentColor)
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView, result: self.$result)
            }
        }
        .listStyle(.plain)
    }
    //Reminders View
    var reminders: some View {
        List {
            //Enter Reminder Title
            TextField("Title", text: $reminderName)
            //Enter Reminder Notes
            TextField("Notes", text: $reminderNotes)
            //Picker To Choose Reminder Priority
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
            //Date Picker To Choose Reminder Due Date
            DatePicker("Due Date", selection: $reminderDate, displayedComponents: .date)
        }
        .listStyle(.plain)
        //New Reminder View Title
        .navigationTitle("New Reminder")
        .task {
            //Request Access To Read And Write To Reminders
            RemindersSync().requestRemindersAccess() { result in
                if result == true {
                    print("Access Granted")
                } else {
                    print("Acces Denied")
                }
            }
            //Fetch Existing Reminders From Calendar Store
            RemindersSync().fetchReminders()
        }
        .toolbar {
            //Done Button To Create Reminder And Store It In Reminders Store
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    let val = 0
                    let nextTriggerDate = Calendar.current.date(byAdding: .day, value: val, to: reminderDate)!
                    let comps = Calendar.current.dateComponents([.year, .month, .day], from: nextTriggerDate)
                    RemindersSync().createReminder(title: reminderName, priority: reminderPriority, notes: reminderNotes, date: comps)
                }) {
                    Text("Done")
                }
                .disabled(newReminderDisabled)
            }
        }
        .onAppear() {
            if reminderName == "" {
                self.newReminderDisabled = true
            } else {
                self.newReminderDisabled = false
            }
        }
    }
    //Calendar View
    var calendar: some View {
        VStack {
            //List To Show Existing Events In The Calendar Store (Depending On Which Calendar Is Selected)
            List {
                //Shows If No Events Are Found
                if eventsRepository.events?.isEmpty ?? true {
                    Text("No Events Avaliable For That Calendar")
                }
                //Display Fetched Events In List
                ForEach(eventsRepository.events ?? [], id: \.self) { event in
                    EventRow(event: event)
                        .onTapGesture {
                            self.showEditFor(event)
                        }
                    }
                }
            .listStyle(.plain)
                //List Of Selected Calendars
                SelectedCalendarsList(selectedCalendars: Array(eventsRepository.selectedCalendars ?? []))
                    .padding(.vertical)
                    .padding(.horizontal, 5)
                //Button To Choose Calendars To Show
                Button(action: {
                    self.activeSheet = .calendarChooser
                    self.showingSheet = true
                }) {
                    Text("Select Calendars")
                }
                //Apply Custom Button Style
                .buttonStyle(PrimaryButtonStyle())
                .sheet(isPresented: $showingSheet) {
                    if self.activeSheet == .calendarChooser {
                        CalendarChooser(calendars: self.$eventsRepository.selectedCalendars, eventStore: self.eventsRepository.eventStore)
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        EventEditView(eventStore: self.eventsRepository.eventStore, event: self.selectedEvent)
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                .padding(.bottom)
        }
        //Set View Title To Calendar
        .navigationTitle("Calendar")
        //Toolbar Button To Add A New Event
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Feedback Button Send Mail View
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
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
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
        return Coordinator(isShowing: $isShowing, result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {

    }
}
