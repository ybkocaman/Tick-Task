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
    @State private var priority: Int16 = 2
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Task Name")
                            .bold()
                        TextField("Enter Task Name Here...", text: $name)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 10))
                        Divider()
                            .padding(.vertical, 10)
                        Text("Task Description")
                            .bold()
                        TextField("Enter Task Description Here...", text: $taskDescription)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 5)
                    .padding()
                    
                    
                    HStack {
                        Text("Priority")
                            .bold()
                            .foregroundStyle(.white)
                        Spacer()
                        Picker("Priority", selection: $priority) {
                            Text("High")
                                .tag(Int16(1))
                            
                            Text("Medium")
                                .tag(Int16(2))
                            
                            Text("Low")
                                .tag(Int16(3))
                        }
                        .tint(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 11)
                    .background(getPriorityColor(priority: priority).opacity(0.7))
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 5)
                    .padding()
                    
                    
                    HStack {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                            .background(Color.gray.opacity(0))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 5)
                    .padding()
                    
                }
                .padding()
            }
            
//            .background(Color.green.opacity(0.5))
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
    
    private func getPriorityColor(priority: Int16) -> Color {
        switch priority {
        case 1:
            return .red
        case 2:
            return .yellow
        default:
            return .blue
        }
    }
}
