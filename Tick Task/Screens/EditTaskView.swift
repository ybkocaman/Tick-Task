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
    @State private var isCompleted: Bool
    
    @State private var isShowingAlert = false
    
    init(task: Task) {
        _name = State(initialValue: task.name ?? "")
        _taskDescription = State(initialValue: task.taskDescription ?? "")
        _dueDate = State(initialValue: task.dueDate ?? Date())
        _priority = State(initialValue: task.priority)
        _isDueTime = State(initialValue: task.isDueTime)
        _dueTime = State(initialValue: task.dueTime)
        _isCompleted = State(initialValue: task.isCompleted)
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
                            saveTask()
                        } label: {
                            AppButton(title: "Save", isFilledBackground: true, fontColor: .white, buttonColor: .blue)
                        }
                        
                        Button {
                            isShowingAlert.toggle()
                        } label: {
                            AppButton(title: "Delete Task", systemName: "trash", isFilledBackground: false, fontColor: .red, buttonColor: .red)
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
        if task.isDueTime {
            NotificationManager.shared.removeNotification(for: task)
        }
        
        task.name = name
        task.taskDescription = taskDescription
        task.dueDate = dueDate
        task.priority = priority
        task.isDueTime = isDueTime
        task.isCompleted = isCompleted
        
        if isDueTime, let dueTime = dueTime {
            var components = Calendar.current.dateComponents([.hour, .minute], from: dueTime)
            components.year = Calendar.current.component(.year, from: dueDate)
            components.month = Calendar.current.component(.month, from: dueDate)
            components.day = Calendar.current.component(.day, from: dueDate)
            task.dueTime = Calendar.current.date(from: components)
        } else {
            task.dueTime = nil
        }

        try? moc.save()
        feedbackManager.showFeedback(message: "Task saved")
        
        if task.isDueTime {
            NotificationManager.shared.scheduleNotification(for: task)
        }
        
        NotificationManager.shared.scheduleDailySummaryNotification(moc: moc)
        NotificationManager.shared.scheduleEveningSummaryNotification(moc: moc)
        
        dismiss()
    }
    
    private func deleteTask() {
        if task.isDueTime {
            NotificationManager.shared.removeNotification(for: task)
        }
        
        moc.delete(task)
        try? moc.save()
        feedbackManager.showFeedback(message: "Task deleted")
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
