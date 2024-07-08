//
//  ContentView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isShowingAddSheet = false

    var body: some View {
        
        NavigationStack {
            ScrollView {
                TaskListView()
                    .navigationTitle("Tick Task")
                    .toolbar {
                        Button("Add Task", systemImage: "plus") { isShowingAddSheet.toggle() }
    
                        Menu {
                            NavigationLink {
                                PreviousTaskListView()
                            } label: {
                                HStack {
                                    Text("Previous Tasks")
                                    Image(systemName: "clock")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
    
                    }
                    .sheet(isPresented: $isShowingAddSheet) { AddTaskView() }

            }
        }
        
    }
}
