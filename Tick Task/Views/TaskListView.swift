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
            ForEach(groupedTasks.keys.sorted(), id: \.self) { date in
                DayBoxView(tasks: groupedTasks[date] ?? [], date: date)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }
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
    
}
