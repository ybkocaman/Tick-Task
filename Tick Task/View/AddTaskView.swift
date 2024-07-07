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
    @State private var priority = 2
    
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
                    Picker("Priority", selection: $priority) {
                        HStack {
                            Text("1")
                            Image(systemName: "circle.fill")
                                .tint(.red)
                        }.tag(1)

                        HStack {
                            Text("2")
                            Image(systemName: "circle.fill")
                                .tint(.yellow)
                        }.tag(2)
                        
                        HStack {
                            Text("3")
                            Image(systemName: "circle.fill")
                                .tint(.blue)
                        }.tag(3)

                    }
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
        newTask.priority = Int16(priority)
        try? moc.save()
        dismiss()
    }
}
