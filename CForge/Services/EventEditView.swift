//
//  EventEditView.swift
//  CForge
//
//  Created by Kartikey Chaudhary on 12/04/26.
//
import SwiftUI
import EventKit
import EventKitUI

struct EventEditView: UIViewControllerRepresentable {
    let eventStore: EKEventStore
    let event: EKEvent?
    
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.eventStore = eventStore
        eventEditViewController.event = event
        eventEditViewController.editViewDelegate = context.coordinator
        return eventEditViewController
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        let parent: EventEditView

        init(_ parent: EventEditView) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
