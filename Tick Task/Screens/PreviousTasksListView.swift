//
//  PreviousTasksListView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 04/07/2024.
//

import SwiftUI

struct PreviousTasksListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: false)]) var tasks: FetchedResults<Task>
    
    @State private var searchText = ""

    var body: some View {
        
        NavigationStack {
            
            if groupedTasks.keys.sorted(by: >).isEmpty {
                
                EmptyStateView(imageSystemName: "calendar.badge.clock", header: "No Previous Tasks")
                
            } else {
                
                ScrollView {
                    
                    ForEach(groupedTasks.keys.sorted(by: >), id: \.self) { date in
                        DayBoxView(tasks: groupedTasks[date] ?? [], date: date)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    .searchable(text: $searchText, prompt: "Search task")

                }
                
            }

        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    ToolbarBackButton()
                }

            }
        }
        
        .navigationTitle("Previous Tasks")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .background(Color("AppBackground"))
    }
    
    private var groupedTasks: [Date: [Task]] {
        let filteredTasks = tasks.filter { task in
            searchText.isEmpty ||
            task.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
            task.taskDescription?.localizedCaseInsensitiveContains(searchText) ?? false
        }
        
        let tasksToShow = filteredTasks.filter { task in
            return task.dueDate! < Calendar.current.startOfDay(for: Date())
        }
        
        return Dictionary(grouping: tasksToShow, by: { task in
            Calendar.current.startOfDay(for: task.dueDate ?? Date())
        })
    }

}
