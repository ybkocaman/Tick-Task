//
//  NotificationManager.swift
//  Tick Task
//
//  Created by Yusuf Burak on 13/07/2024.
//

import CoreData
import Foundation
import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()
    private init() { }
    
    
    func scheduleNotification(for task: Task) {
        guard let dueTime = task.dueTime else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Due"
        content.body = "\(task.name ?? "Your task") is due now!"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id!.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            }
        }
    }
    
    
    func removeNotification(for task: Task) {
        guard let taskId = task.id?.uuidString else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId])
    }
    
    
    func scheduleDailySummaryNotification(moc: NSManagedObjectContext) {
        let taskCount = fetchTaskCount(for: Date(), in: moc)
        
        let content = UNMutableNotificationContent()
        content.title = "Today's Tasks"
        content.body = "You have \(taskCount) tasks scheduled for today. Tap to see them."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailySummary", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily summary notification: \(error.localizedDescription)")
            }
        }
    }
    
    
    func scheduleEveningSummaryNotification(moc: NSManagedObjectContext) {
        let todayTaskCount = fetchUncompletedTaskCount(for: Date(), in: moc)
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowTaskCount = fetchTaskCount(for: tomorrowDate, in: moc)
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Summary"
        
        switch (todayTaskCount, tomorrowTaskCount) {
        case (0, 0):
            content.body = "Congratulations! All tasks for today are completed, and you have no tasks scheduled for tomorrow. Tap to see your list."
        case (0, _):
            content.body = "Congratulations! All tasks for today are completed. You have \(tomorrowTaskCount) tasks scheduled for tomorrow. Tap to see your list."
        case (_, 0):
            content.body = "You have \(todayTaskCount) unfinished tasks for today. You have no tasks scheduled for tomorrow. Tap to see your list."
        default:
            content.body = "You have \(todayTaskCount) unfinished tasks for today and \(tomorrowTaskCount) tasks scheduled for tomorrow. Tap to see your list."
        }
        
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 22
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "eveningSummary", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling evening summary notification: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func fetchTaskCount(for date: Date, in context: NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        fetchRequest.predicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks.count
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
            return 0
        }
    }
    
    
    private func fetchUncompletedTaskCount(for date: Date, in context: NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        fetchRequest.predicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@ AND isCompleted == %@", startOfDay as NSDate, endOfDay as NSDate, NSNumber(value: false))
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks.count
        } catch {
            print("Failed to fetch uncompleted tasks: \(error.localizedDescription)")
            return 0
        }
    }
    
}
