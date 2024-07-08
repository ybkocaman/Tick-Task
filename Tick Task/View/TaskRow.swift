//
//  TaskRow.swift
//  Tick Task
//
//  Created by Yusuf Burak on 04/07/2024.
//

import SwiftUI

struct TaskRow: View {
    
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var task: Task
    
    var body: some View {
        NavigationLink {
            EditTaskView(task: task)
        } label: {
            
            HStack {
                let priorityColor = getPriorityColor(priority: task.priority)
                Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                    .foregroundStyle(.gray)
                    .font(.title)
                    .onTapGesture { toggleTaskCompletion(task) }
                VStack(alignment: .leading) {
                    HStack {
                        Text(task.name ?? "Task name unavailable")
                            .bold()
                        Text("8pm")
                        Spacer()
                    }
                    Text(task.taskDescription ?? "")
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(.black)
                .strikethrough(task.isCompleted)
                Image(systemName: "square.fill")
                    .foregroundStyle(priorityColor.opacity(0.7))
                    .font(.title3)
                
                
            }
            .opacity(task.isCompleted ? 0.5 : 1)
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(task.isCompleted ? .gray.opacity(0.1) : .white)
            .overlay(
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .stroke(Color.gray.opacity(0.3), lineWidth: 3)
            )
            .clipShape(.rect(cornerRadius: 20))
        }
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
    
    func toggleTaskCompletion(_ task: Task) {
        task.isCompleted.toggle()
        try? moc.save()
    }
}
