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
    
    @State private var isShowingAlert = false
    
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
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .clipShape(.rect(cornerRadius: 15))
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
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .clipShape(.rect(cornerRadius: 15))
                    
                    .shadow(radius: 1)
                    .padding(.horizontal)
                    
                    
                    HStack {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                            .background(Color.gray.opacity(0))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .clipShape(.rect(cornerRadius: 15))
                    .padding()
                    
                    
                    VStack(spacing: 15) {
                        
                        Button {
                            task.isCompleted.toggle()
                        } label: {
                            HStack {
                                Image(systemName: task.isCompleted ? "square" : "checkmark.square")
                                Text(task.isCompleted ? "Mark Uncompleted" : "Mark Completed")
                            }
                            .frame(maxWidth: .infinity)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(9)
                            .background(task.isCompleted ? .black : .green)
                            .clipShape(Capsule())
                            
                        }
                        
                        
                        Button {
                            isShowingAlert.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Task")
                            }
                            .frame(maxWidth: .infinity)

                            .foregroundStyle(.red)
                            .padding(9)
                            .overlay(
                                Capsule()
                                    .stroke(Color.red, lineWidth: 3)
                            )
                            .clipShape(Capsule())
                        }
                        
                        
                        Button {
                            saveTask()
                        } label: {
                            Text("Save")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .padding(9)
                                .background(.blue)
                                .clipShape(Capsule())
                        }
                    }
                    .padding()
                }
                .padding()

            }
            
            .navigationTitle("Edit Task")
            .alert("WARNING", isPresented: $isShowingAlert) {
                Button("Delete", role: .destructive) { deleteTask() }
            } message: {
                Text("Are you sure about deleting this task?")
            }
            .background(Color.green.opacity(0.3))
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
    
    private func deleteTask() {
        moc.delete(task)
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
