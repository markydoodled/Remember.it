//
//  EventRow.swift
//  Remember.it
//
//  Created by Mark Howard on 13/01/2023.
//

import SwiftUI
import EventKit

//Calendar Event Row To Iterate
struct EventRow: View {
    //Init Event
    let event: EKEvent
    
    //Format Date
    private static var relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter
    }()
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private static func formatDate(forNonAllDayEvent event: EKEvent) -> String {
        return "\(EventRow.dateFormatter.string(from: event.startDate)) - \(EventRow.dateFormatter.string(from: event.endDate))"
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(event.color)
                .frame(width: 10, height: 10, alignment: .center)
                
            
            VStack(alignment: .leading) {
                Text(EventRow.relativeDateFormatter.localizedString(for: event.startDate, relativeTo: Date()).uppercased())
                    .modifier(SecondaryCaptionTextStyle())
                    .padding(.bottom, 2)
                Text(event.title)
                    .font(.headline)
            }
            
            Spacer()
            
            VStack {
                Spacer()
                Text(event.isAllDay ? "all day" : EventRow.formatDate(forNonAllDayEvent: event))
                    .modifier(SecondaryCaptionTextStyle())
            }
        }.padding(.vertical, 5)
    }
}
