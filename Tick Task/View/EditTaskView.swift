//
//  EditTaskView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import SwiftUI

struct EditTaskView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var task: Task
    
    @State private var name: String
    @State private var taskDescription: String
    @State private var dueDate: Date
    @State private var priority: Int16
    
    init(task: Task) {
        _name = State(initialValue: task.name ?? "")
        _taskDescription = State(initialValue: task.taskDescription ?? "")
        _dueDate = State(initialValue: task.dueDate ?? Date())
        _priority = State(initialValue: task.priority)
        self.task = task
    }
    
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
                                .foregroundStyle(.red)
                            Image(systemName: "circle.fill")
                                .foregroundStyle(.red)
                        }.tag(Int16(1))
                        
                        HStack {
                            Text("2")
                            Image(systemName: "circle.fill")
                                .foregroundStyle(.yellow)
                        }.tag(Int16(2))
                        
                        HStack {
                            Text("3")
                            Image(systemName: "circle.fill")
                                .tint(.blue)
                        }.tag(Int16(3))
                    }
                }
                
                Section {
                    DatePicker("Select Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            
            .navigationTitle("Edit task")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { saveTask() }
                }
            }
        }
    }
    
    private func saveTask() {
        task.name = name
        task.taskDescription = taskDescription
        task.dueDate = dueDate
        task.priority = priority
        try? moc.save()
        dismiss()
    }
    
}
