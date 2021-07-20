//
//  Reminders.swift
//  Remember.it
//
//  Created by Mark Howard on 19/07/2021.
//

import SwiftUI

struct Reminders: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        if horizontalSizeClass == .compact {
            NavigationView {
                Text("Test")
                    .navigationTitle("Reminders")
            }
        } else {
            Text("Test")
                .navigationTitle("Reminders")
        }
    }
}

struct Reminders_Previews: PreviewProvider {
    static var previews: some View {
        Reminders()
    }
}
