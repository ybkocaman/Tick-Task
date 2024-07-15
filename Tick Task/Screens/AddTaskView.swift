//
//  AddTaskView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import StoreKit
import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @Environment(\.requestReview) private var requestReview
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<Task>
    
    @EnvironmentObject var feedbackManager: FeedbackManager
    
    @State private var name = ""
    @State private var taskDescription = ""
    @State private var dueDate = Date()
    @State private var priority: Int16 = 2
    @State private var isDueTime = false
    @State private var dueTime: Date? = nil
    
    @AppStorage("taskCount") private var taskCount = 0
    @AppStorage("reviewRequested") private var reviewRequested = false
    
    var body: some View {
        
        NavigationStack {
                
            ScrollView {
                
                TaskNameAndDescriptionBoxView(name: $name, taskDescription: $taskDescription)
                    .padding()
                
                PriorityBoxView(priority: $priority)
                    .padding(.horizontal)
                TaskDateAndTimeBoxView(dueDate: $dueDate, isDueTime: $isDueTime, dueTime: $dueTime)
                    .padding()
                
                Button {
                    addTask()
                } label: {
                    AppButton(title: "Add Task", isFilledBackground: true, fontColor: .white, buttonColor: .blue)
                }

                .padding()
                
            }
            .scrollDismissesKeyboard(.immediately)
            .animation(.easeInOut, value: isDueTime)
            .animation(.smooth, value: priority)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        ToolbarBackButton()
                    }
                }
            }
            
            .navigationTitle("Add New Task")
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.mint.opacity(0.3))
        }
        
    }
    
    private func addTask() {
        let newTask = Task(context: moc)
        newTask.id = UUID()
        newTask.name = name.isEmpty ? "New Task" : name
        newTask.isCompleted = false
        newTask.taskDescription = taskDescription
        newTask.dueDate = dueDate
        newTask.priority = Int16(priority)
        newTask.isDueTime = isDueTime
        
        if isDueTime, let dueTime = dueTime {
            var components = Calendar.current.dateComponents([.hour, .minute], from: dueTime)
            components.year = Calendar.current.component(.year, from: dueDate)
            components.month = Calendar.current.component(.month, from: dueDate)
            components.day = Calendar.current.component(.day, from: dueDate)
            newTask.dueTime = Calendar.current.date(from: components)
        } else {
            newTask.dueTime = nil
        }
        
        try? moc.save()
        feedbackManager.showFeedback(message: "Task added")

        if newTask.isDueTime {
            NotificationManager.shared.scheduleNotification(for: newTask)
            if UserDefaults.standard.bool(forKey: "NotificationPermissionRequested") == false {
                requestPermissions()
            }
        }
        
        if !reviewRequested {
            if taskCount < 10 {
                taskCount += 1
                print("Task count: \(taskCount)")
            } else {
                requestReview()
                reviewRequested = true
            }
        }
        
        dismiss()
    }
    
    private func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: "NotificationPermissionRequested")
            }
        }
    }
    
}

#Preview {
    AddTaskView()
}
