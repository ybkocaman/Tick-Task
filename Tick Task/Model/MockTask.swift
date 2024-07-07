//
//  MockTask.swift
//  Tick Task
//
//  Created by Yusuf Burak on 07/07/2024.
//

import Foundation

struct MockTask {
    var id: UUID
    var name: String
    var taskDescription: String
    var priority: Int16
    var dueDate: Date
    var isCompleted: Bool
    
    static let sampleTasks = [
        MockTask(id: UUID(), name: "Buy groceries", taskDescription: "No desc", priority: 2, dueDate: Date(), isCompleted: false),
        MockTask(id: UUID(), name: "Finish Project", taskDescription: "No desc", priority: 1, dueDate: Date(), isCompleted: false),
        MockTask(id: UUID(), name: "Buy groceries", taskDescription: "No desc", priority: 3, dueDate: Date(), isCompleted: false),
    ]
}


//let sampleTasks = [
//    MockTask(id: UUID(), name: "Buy groceries", taskDescription: "No desc", priority: 1, dueDate: Date(), isCompleted: false)
//]

//static let sampleTasks = [
//    MockTask(id: UUID(), name: false, taskDescription: "Buy groceries", priority: 1, dueDate: "Milk, Eggs, Bread"),
//    MockTask(id: UUID(), isCompleted: true, name: "Finish project", priority: 2, taskDescription: "Complete the project report"),
//    MockTask(id: UUID(), isCompleted: false, name: "Exercise", priority: 3, taskDescription: "Morning run for 30 minutes")
//]

