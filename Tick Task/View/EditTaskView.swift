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
            
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Task Name")
                            .bold()
                        TextField("Task Name", text: $name)
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
                    
                    
                    
                    HStack {
                        Button {
                            task.isCompleted.toggle()
                        } label: {
                            Text(task.isCompleted ? "Mark Uncompleted" : "Mark Completed")
                                .bold()
                                .foregroundStyle(.white)
                                .padding(15)
                                .background(task.isCompleted ? .black : .green)
                                .clipShape(.rect(cornerRadius: 20))
                                .padding(.vertical)
                                .padding(.leading)
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Task")
                            }
                            .foregroundStyle(.red)
                            .padding(15)
                            .overlay(
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                    .stroke(Color.red, lineWidth: 3)
                            )
                            .clipShape(.rect(cornerRadius: 20))
                            .padding(.vertical)
                            .padding(.trailing)
                    }
                    }
                    
                }
                .padding()

            }
            .navigationTitle("Edit Task")
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


#Preview {
    let context = PersistenceController.preview.container.viewContext
    let task = Task(context: context)
    task.id = UUID()
    task.name = "Sample Task"
    task.taskDescription = "This is a sample task description."
    task.dueDate = Date()
    task.priority = 1
    
    return EditTaskView(task: task)
        .environment(\.managedObjectContext, context)
}
