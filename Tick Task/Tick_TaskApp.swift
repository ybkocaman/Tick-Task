//
//  Tick_TaskApp.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import SwiftUI

@main
struct Tick_TaskApp: App {
    @StateObject private var dataController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
