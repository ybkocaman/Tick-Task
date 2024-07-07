//
//  TaskBox.swift
//  Tick Task
//
//  Created by Yusuf Burak on 07/07/2024.
//

import SwiftUI

struct TaskBox: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)]) var tasks: FetchedResults<Task>
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Today")
                    Text("• Sunday")
                        .foregroundStyle(.secondary)
                }
                ForEach(tasks) { task in
                    HStack {
                        let priorityColor = getPriorityColor(priority: task.priority)
                        Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                            .font(.title)
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
                        .strikethrough(task.isCompleted)
                        Image(systemName: "square.fill")
                            .foregroundStyle(priorityColor.opacity(0.7))
                            .font(.title)
                        

                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(task.isCompleted ? .gray.opacity(0.3) : .white)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .stroke(Color.gray, lineWidth: 3) // Border color and width
                    )
//                    .background(Color(.blue).opacity(0.5))
                    .clipShape(.rect(cornerRadius: 10))
                    
                }
            }
            Spacer()

        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 10)
//        VStack(alignment: .leading) {
//            ForEach(tasks, id: \.id) { task in
//                HStack {
//                    Text(task.name ?? "")
//                        .font(.headline)
//                    Spacer()
//                    if task.isCompleted {
//                        Image(systemName: "checkmark.circle")
//                    }
//                }
//                Text(task.taskDescription ?? "")
//                    .font(.subheadline)
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(8)
    }
    
    func getPriorityColor(priority: Int16) -> Color {
        if priority == 1 {
            return .red
        } else if priority == 2 {
            return .yellow
        } else {
            return .blue
        }
    }
}

#Preview {
    TaskBox()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .previewLayout(.sizeThatFits)
        .padding()
}
