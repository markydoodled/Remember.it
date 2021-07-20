//
//  Calendar.swift
//  Remember.it
//
//  Created by Mark Howard on 19/07/2021.
//

import SwiftUI

struct Calendar: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var activeSheet: ActiveSheet?
    var body: some View {
        if horizontalSizeClass == .compact {
            NavigationView {
                Text("Test")
                    .navigationTitle("Calendar")
            }
        } else {
            Text("Test")
                .navigationTitle("Calendar")
    }
}
}

struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        Calendar()
    }
}

enum ActiveSheet: Identifiable {
    case theme, add
    
    var id: Int {
        hashValue
    }
}
