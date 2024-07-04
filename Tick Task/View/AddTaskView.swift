//
//  AddTaskView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<Task>
    
    @State private var name = ""
    @State private var taskDescription = ""
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationStack {
            
            Form {
                Section("Task Name") {
                    TextField("Enter Task Name Here...", text: $name)
                }
                Section("Task Description") {
                    TextField("Enter Task Description Here...", text: $taskDescription)
                }
                Section {
                    DatePicker("Select Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            
            .navigationTitle("Add a task")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") { addTask() }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    func addTask() {
        let newTask = Task(context: moc)
        newTask.id = UUID()
        newTask.name = name
        newTask.taskDescription = taskDescription
        newTask.dueDate = dueDate
        try? moc.save()
        dismiss()
    }
}
