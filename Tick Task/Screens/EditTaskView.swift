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
    @State private var isDueTime: Bool
    @State private var dueTime: Date?
    
    @State private var isShowingAlert = false
    
    init(task: Task) {
        _name = State(initialValue: task.name ?? "")
        _taskDescription = State(initialValue: task.taskDescription ?? "")
        _dueDate = State(initialValue: task.dueDate ?? Date())
        _priority = State(initialValue: task.priority)
        _isDueTime = State(initialValue: task.isDueTime)
        _dueTime = State(initialValue: task.dueTime)
        self.task = task
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                TaskNameAndDescriptionBoxView(name: $name, taskDescription: $taskDescription)
                    .padding()
                
                PriorityBoxView(priority: $priority)
                    .padding(.horizontal)
                
                TaskDateAndTimeBoxView(dueDate: $dueDate, isDueTime: $isDueTime, dueTime: $dueTime)
                    .padding()
                
                    VStack(spacing: 15) {
                        
                        Button {
                            task.isCompleted.toggle()
                        } label: {
                            
                            if task.isCompleted {
                                AppButton(title: "Mark Uncompleted", systemName: "square", isFilledBackground: true, fontColor: .white, buttonColor: .black)
                            } else {
                                AppButton(title: "Mark Completed", systemName: "checkmark.square", isFilledBackground: true, fontColor: .white, buttonColor: .green)
                            }
                            
                        }
                        
                        Button {
                            isShowingAlert.toggle()
                        } label: {
                            AppButton(title: "Delete Task", systemName: "trash", isFilledBackground: false, fontColor: .red, buttonColor: .red)
                        }
                        
                        Button {
                            saveTask()
                        } label: {
                            AppButton(title: "Save", isFilledBackground: true, fontColor: .white, buttonColor: .blue)
                        }
                    }
                    .padding()

            }
            
            .navigationTitle("Edit Task")
            .alert("WARNING", isPresented: $isShowingAlert) {
                Button("Delete", role: .destructive) { deleteTask() }
            } message: {
                Text("Are you sure about deleting this task?")
            }
            .background(Color.mint.opacity(0.3))
        }
    }
    
    private func saveTask() {
        task.name = name
        task.taskDescription = taskDescription
        task.dueDate = dueDate
        task.priority = priority
        task.isDueTime = isDueTime
        task.dueTime = dueTime
        try? moc.save()
        dismiss()
    }
    
    private func deleteTask() {
        moc.delete(task)
        try? moc.save()
        dismiss()
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
