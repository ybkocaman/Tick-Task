//
//  TaskListView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 02/07/2024.
//

import SwiftUI

struct TaskListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)]) var tasks: FetchedResults<Task>
            
    var body: some View {
        VStack {
            List {
                ForEach(groupedTasks.keys.sorted(), id: \.self) { date in
                    Section {
                        ForEach(groupedTasks[date]!) { task in
                            TaskRow(task: task)
                        }
                        .onDelete { indexSet in
                            deleteTask(indexSet, date: date)
                        }
                    } header: {
                        Text(dateFormatted(date))
                    }

                }
            }
        }
    }
    
    private func deleteTask(_ offsets: IndexSet, date: Date) {
        if let tasksForDate = groupedTasks[date] {
            for index in offsets {
                let taskToDelete = tasksForDate[index]
                if let globalIndex = tasks.firstIndex(where: { $0.objectID == taskToDelete.objectID }) {
                    moc.delete(tasks[globalIndex])
                }
            }
            try? moc.save()
        }
    }
    
    private var groupedTasks: [Date: [Task]] {
        let tasksToShow = tasks.filter { task in
            return task.dueDate! >= Calendar.current.startOfDay(for: Date())
        }
        
        return Dictionary(grouping: tasksToShow, by: { task in
            Calendar.current.startOfDay(for: task.dueDate ?? Date())
        })
    }
    
    private func dateFormatted(_ date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        if calendar.isDate(date, inSameDayAs: today) {
            return "Today"
        } else if calendar.isDate(date, inSameDayAs: tomorrow) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, d MMMM"
            return formatter.string(from: date)
        }
    }
    
}
