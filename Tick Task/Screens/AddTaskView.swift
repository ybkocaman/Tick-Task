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
    @State private var isDueTime = false
    @State private var dueTime: Date? = Date()
    
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
                    AddTaskButton()
                }
                .padding()
            }
            
            .navigationTitle("Add a task")
            .background(Color.mint.opacity(0.3))
        }
    }
    
    func addTask() {
        let newTask = Task(context: moc)
        newTask.id = UUID()
        newTask.name = name
        newTask.taskDescription = taskDescription
        newTask.dueDate = dueDate
        newTask.priority = Int16(priority)
        newTask.isDueTime = isDueTime
        try? moc.save()
        dismiss()
    }
    

}

#Preview {
    AddTaskView()
}
