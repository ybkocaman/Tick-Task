//
//  PersistenceManager.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import CoreData
import Foundation

class PersistenceManager: ObservableObject {
    static let shared = PersistenceManager()

    let container = NSPersistentContainer(name: "TickTask")

    init(inMemory: Bool = false) {

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static var preview: PersistenceManager = {
        let controller = PersistenceManager(inMemory: true)
        let viewContext = controller.container.viewContext

        // Create sample data for preview
        for index in 0..<5 {
            let task = Task(context: viewContext)
            task.id = UUID()
            task.isCompleted = index % 2 == 0
            task.name = "Sample Task \(index)"
            task.priority = Int16(index)
            task.taskDescription = "Description for task \(index)"
            task.dueDate = Date()
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()
}
