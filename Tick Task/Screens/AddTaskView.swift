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
    @State private var dueTime: Date? = nil
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, description
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
                        addTask()
                    } label: {
                        AppButton(title: "Add Task", isFilledBackground: true, fontColor: .white, buttonColor: .blue)
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        AppButton(title: "Cancel", isFilledBackground: false, fontColor: .black, buttonColor: .black)
                    }
                }
                .padding()

            }
//            .onTapGesture {
//                focusedField = nil
//            }
            .navigationTitle("Add a new task")
            .navigationBarBackButtonHidden()
            .background(Color.mint.opacity(0.3))
        }

    }
    
    func addTask() {
        let newTask = Task(context: moc)
        newTask.id = UUID()
        if name != "" {
            newTask.name = name
        } else {
            newTask.name = "New Task"
        }
        newTask.taskDescription = taskDescription
        newTask.dueDate = dueDate
        newTask.priority = Int16(priority)
        newTask.isDueTime = isDueTime
        newTask.dueTime = dueTime
        try? moc.save()
        dismiss()
    }
    

}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddTaskView()
}
