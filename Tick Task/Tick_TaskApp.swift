//
//  Tick_TaskApp.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import StoreKit
import SwiftUI

@main
struct Tick_TaskApp: App {
    
    @StateObject private var dataController = PersistenceManager()
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onAppear {
                    scheduleNotifications()
                    addObservers()
                }
        }
    }
    
    private func scheduleNotifications() {
        let moc = dataController.container.viewContext
        NotificationManager.shared.scheduleDailySummaryNotification(moc: moc)
        NotificationManager.shared.scheduleEveningSummaryNotification(moc: moc)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: dataController.container.viewContext, queue: .main) { _ in
            scheduleNotifications()
        }
    }

}
