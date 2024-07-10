//
//  MainScreen.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import SwiftUI

struct MainScreen: View {
        
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                ScrollView {
                    TaskListView()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink {
                            AddTaskView()
                        } label: {
                            Image(systemName: "plus")
                                .font(.largeTitle.bold())
                                .foregroundStyle(.black)
                                .padding()
                                .background(Color.brown.opacity(0.8))
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(.black, lineWidth: 3)
                                }
                                .padding(.bottom, 50)
                                .padding(.trailing, 30)
                        }
                    }
                }
                .ignoresSafeArea()
            }
            .padding(.top)
            .background(Color.mint.opacity(0.3))
            .navigationTitle("Tick Task")
            .toolbar {
                Menu {
                    NavigationLink {
                        PreviousTasksListView()
                    } label: {
                        HStack {
                            Text("Previous Tasks")
                            Image(systemName: "clock")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .bold()
                        .foregroundStyle(.black)
                }
            }
        }

    }
}

#Preview {
    MainScreen()
}
