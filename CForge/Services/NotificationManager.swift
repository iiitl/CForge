//
//  NotificationManager.swift
//  CForge
//
//  Created by Kartikey Chaudhary on 12/04/26.
//
import Foundation
import UserNotifications
import UIKit

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private let defaultsKey = "savedContestReminders"
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func checkStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func scheduleReminder(for contestId: Int, title: String, startTime: Date, isRated: Bool) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Contest: \(title)"
        let ratedString = isRated ? "Rated" : "Unrated"
        content.body = "This \(ratedString) contest starts at \(startTime.formatted(date: .omitted, time: .shortened))."
        content.sound = .default
        
        let timeUntilStart = startTime.timeIntervalSinceNow
        var reminderOffset: TimeInterval = 30 * 60
        
        if timeUntilStart < 30 * 60 {
            reminderOffset = 5 * 60
        }
        
        let reminderTime = startTime.addingTimeInterval(-reminderOffset)
        
        guard reminderTime > Date() else { return }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "contest_\(contestId)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        var saved = UserDefaults.standard.array(forKey: defaultsKey) as? [Int] ?? []
        if !saved.contains(contestId) {
            saved.append(contestId)
            UserDefaults.standard.set(saved, forKey: defaultsKey)
        }
        
        cleanupPastReminders()
    }
    
    func removeReminder(for contestId: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["contest_\(contestId)"])
        
        var saved = UserDefaults.standard.array(forKey: defaultsKey) as? [Int] ?? []
        saved.removeAll { $0 == contestId }
        UserDefaults.standard.set(saved, forKey: defaultsKey)
    }
    
    func isReminderSet(for contestId: Int) -> Bool {
        let saved = UserDefaults.standard.array(forKey: defaultsKey) as? [Int] ?? []
        return saved.contains(contestId)
    }
    
    func cleanupPastReminders() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
