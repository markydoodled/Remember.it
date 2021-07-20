//
//  ContentView.swift
//  Remember.it
//
//  Created by Mark Howard on 19/07/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showingSettings = false
    @State var tabSelection = 1
    var body: some View {
        if horizontalSizeClass == .compact {
            TabView(selection: $tabSelection) {
                Calendar()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                Reminders()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "lightbulb")
                        Text("Reminders")
                    }
            }
        } else {
            NavigationView {
                side
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
    var settings: some View {
        NavigationView {
            Form {
                Section(header: Label("Info", systemImage: "info.circle")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0")
                }
                HStack {
                    Text("Build")
                    Spacer()
                    Text("1")
                }
            }
            }
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
    var side: some View {
        List {
            NavigationLink(destination: Calendar()) {
                Label("Calendar", systemImage: "calendar")
            }
            NavigationLink(destination: Reminders()) {
                Label("Reminders", systemImage: "lightbulb")
            }
        }
        .navigationTitle("Remember.it")
        .listStyle(SidebarListStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {self.showingSettings = true}) {
                    Image(systemName: "gearshape")
                }
                .sheet(isPresented: $showingSettings) {
                    settings
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
