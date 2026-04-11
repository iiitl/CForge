//
//  CalendarService.swift
//  CForge
//
//  Created by Harshit Raj on 10/04/26.
//

import SwiftUI
import EventKit

@MainActor
class CalendarService: ObservableObject {
    let calendarStore = EKEventStore()
    
    func requestAccess()async -> Bool {
        do{
            if #available(iOS 17.0, *){
                return try await calendarStore.requestFullAccessToEvents()
            }
            else{
                return try await withCheckedThrowingContinuation { continuation in
                    calendarStore.requestAccess(to: .event) { granted, error in
                        if let error = error { continuation.resume(throwing: error) }
                        else { continuation.resume(returning: granted) }
                    }
                }
            }
        }
        catch{
            return false
        }
    }
    
    func pinEvents(for contest: ContestListView.CFContest) -> EKEvent {
        let event = EKEvent(eventStore: calendarStore)
        event.title = contest.name
        event.startDate = contest.startTime
        event.endDate = contest.startTime.addingTimeInterval(TimeInterval(contest.durationSeconds))
        
        let alarm = EKAlarm(relativeOffset: -900)
        event.addAlarm(alarm)
        return event
    }
}
