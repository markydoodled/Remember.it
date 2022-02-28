//
//  EventEditView.swift
//  Remember.it
//
//  Created by Mark Howard on 06/02/2022.
//

import SwiftUI
import EventKitUI

struct EventEditView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    let eventStore: EKEventStore
    let event: EKEvent?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<EventEditView>) -> EKEventEditViewController {
        
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.eventStore = eventStore
        
        if let event = event {
            eventEditViewController.event = event
        }
        eventEditViewController.editViewDelegate = context.coordinator
        
        return eventEditViewController
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: UIViewControllerRepresentableContext<EventEditView>) {
        
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        let parent: EventEditView
        
        init(_ parent: EventEditView) {
            self.parent = parent
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
            
            if action != .canceled {
                NotificationCenter.default.post(name: .eventsDidChange, object: nil)
            }
        }
    }
}

