//
//  Tick_TaskApp.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import SwiftUI

@main
struct Tick_TaskApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
