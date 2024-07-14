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
    
    @State private var searchText = ""
            
    var body: some View {
        
        NavigationStack {
            if groupedTasks.isEmpty {
                EmptyStateView(imageSystemName: "calendar.badge.plus", header: "No Upcoming Tasks", message: "You don't have any tasks scheduled.Add a new task to get started!")
            } else {
                ScrollView {
                    ForEach(groupedTasks.keys.sorted(), id: \.self) { date in
                        DayBoxView(tasks: groupedTasks[date] ?? [], date: date)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search task")
                }
            }
        }
    }
    
    private var groupedTasks: [Date: [Task]] {
        let filteredTasks = tasks.filter { task in
            searchText.isEmpty ||
            task.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
            task.taskDescription?.localizedCaseInsensitiveContains(searchText) ?? false
        }
        
        let tasksToShow = filteredTasks.filter { task in
            return task.dueDate! >= Calendar.current.startOfDay(for: Date())
        }
        
        return Dictionary(grouping: tasksToShow, by: { task in
            Calendar.current.startOfDay(for: task.dueDate ?? Date())
        })
    }
    
}
