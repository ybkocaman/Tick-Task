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
    
    @EnvironmentObject var feedbackManager: FeedbackManager
    
    @State private var name: String
    @State private var taskDescription: String
    @State private var dueDate: Date
    @State private var priority: Int16
    @State private var isDueTime: Bool {
        didSet {
            if isDueTime {
                if dueTime == nil {
                    dueTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: dueDate)
                }
            } else {
                dueTime = nil
            }
        }
    }
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
                            saveTask()
                        } label: {
                            AppButton(title: "Save", isFilledBackground: true, fontColor: .white, buttonColor: .blue)
                        }
                        
                        Button {
                            isShowingAlert.toggle()
                        } label: {
                            AppButton(title: "Delete Task", systemName: "trash", isFilledBackground: false, fontColor: .red, buttonColor: .red)
                        }
                        
                        Button {
                            dismiss()
                        } label: {
                            AppButton(title: "Cancel", isFilledBackground: false, fontColor: .black, buttonColor: .black)
                        }
                        
                    }
                    .padding()

            }
            .animation(.easeInOut, value: isDueTime)
            .animation(.smooth, value: priority)
            
            .alert("Deleting Task", isPresented: $isShowingAlert) {
                Button("Delete", role: .destructive) { deleteTask() }
            } message: {
                Text("Would you like to proceed?")
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        ToolbarBackButton()
                    }

                }
            }
            
            .navigationTitle("Edit Task")
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.mint.opacity(0.3))
        }
    }
    
    private func saveTask() {
        if let existingDueTime = task.dueTime {
            NotificationManager.shared.removeNotification(for: task)
        }
        
        task.name = name
        task.taskDescription = taskDescription
        task.dueDate = dueDate
        task.priority = priority
        task.isDueTime = isDueTime

        if isDueTime {
            task.dueTime = dueTime
        } else {
            task.dueTime = nil
        }

        try? moc.save()
        feedbackManager.showFeedback(message: "Task saved")
        
        if task.isDueTime {
            NotificationManager.shared.scheduleNotification(for: task)
        }
        
        dismiss()
    }
    
    private func deleteTask() {
        moc.delete(task)
        try? moc.save()
        feedbackManager.showFeedback(message: "Task deleted")
        NotificationManager.shared.removeNotification(for: task)
        dismiss()
    }
    
}


#Preview {
    let context = PersistenceManager.preview.container.viewContext
    let task = Task(context: context)
    task.id = UUID()
    task.name = "Sample Task"
    task.taskDescription = "This is a sample task description."
    task.dueDate = Date()
    task.priority = 1
    
    return EditTaskView(task: task)
        .environment(\.managedObjectContext, context)
}
