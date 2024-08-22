//
//  TaskRow.swift
//  Tick Task
//
//  Created by Yusuf Burak on 04/07/2024.
//

import SwiftUI

struct TaskRowView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var task: Task
    
    var body: some View {
        NavigationLink {
            EditTaskView(task: task)
        } label: {
            
            HStack {

                Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                    .foregroundStyle(colorScheme == .light ? .gray : .black)
                    .font(.title)
                    .onTapGesture { toggleTaskCompletion(task) }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(task.name ?? "Task name unavailable")
                            .bold()
                            .lineLimit(1)
                            .strikethrough(task.isCompleted)

                        if task.isDueTime {
                            Text("• \(formattedTime(dueTime: task.dueTime))")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if let description = task.taskDescription?.trimmingCharacters(in: .whitespacesAndNewlines), !description.isEmpty {
                        Text(description)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                            .strikethrough(task.isCompleted)
                    }
                }
                .multilineTextAlignment(.leading)
                .foregroundStyle(.black)

                Spacer()
                
                let priorityColor = getPriorityColor(priority: task.priority)
                Image(systemName: "square.fill")
                    .foregroundStyle(priorityColor.opacity(0.5))
                    .font(.title3)
                
                
            }
            .opacity(task.isCompleted ? 0.5 : 1)
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(Color(task.isCompleted ? "CompletedTaskColor" : "UncompletedTaskColor"))
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
    
    private func formattedTime(dueTime: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: dueTime ?? Date())
    }
    
    func toggleTaskCompletion(_ task: Task) {
        withAnimation(.smooth(duration: 0.2)) {
            task.isCompleted.toggle()
            try? moc.save()
        }
    }
}
