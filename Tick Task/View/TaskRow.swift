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
            HStack(alignment: .center) {
                
                Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                    .font(.title.bold())
                    .onTapGesture {
                        withAnimation { task.isCompleted.toggle() }
                        try? moc.save()
                    }
                
                VStack(alignment: .leading) {
                    Text(task.name ?? "Task name not available")
                        .font(.title3.bold())
                    Text(task.taskDescription ?? "Description not available")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .strikethrough(task.isCompleted)
                .padding(5)

            }
            .foregroundStyle(task.isCompleted ? .green : .primary)
        }


    }
}
