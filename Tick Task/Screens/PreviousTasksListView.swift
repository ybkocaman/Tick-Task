//
//  PreviousTasksListView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 04/07/2024.
//

import SwiftUI

struct PreviousTasksListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: false)]) var tasks: FetchedResults<Task>

    var body: some View {
        
        NavigationStack {
        
            ScrollView {
            
                VStack {
                
                    ForEach(groupedTasks.keys.sorted(by: >), id: \.self) { date in
                        DayBoxView(tasks: groupedTasks[date] ?? [], date: date)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                }
                
            }
            
            .navigationTitle("Previous Tasks")
            .background(Color.mint.opacity(0.3))
        }
    }
    
    private var groupedTasks: [Date: [Task]] {
        let tasksToShow = tasks.filter { task in
            return task.dueDate! < Calendar.current.startOfDay(for: Date())
        }
        
        return Dictionary(grouping: tasksToShow, by: { task in
            Calendar.current.startOfDay(for: task.dueDate ?? Date())
        })
    }

}
