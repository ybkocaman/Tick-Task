//
//  MainScreen.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import SwiftUI
import UserNotifications

struct MainScreen: View {

    @StateObject private var feedbackManager = FeedbackManager()
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var themeManager = ThemeManager()
    
    var body: some View {
                
        NavigationStack {
            
            ZStack {
                
                TaskListView()

                AddTaskButton()

            }
            
            .background(Color("AppBackground"))
            .navigationTitle("Tick Task")
            .toolbar {
                            
                Menu {
                    
                    Menu {
                        ForEach(Theme.allCases) { theme in
                            Button {
                                themeManager.selectedTheme = theme
                            } label: {
                                if themeManager.selectedTheme == theme {
                                    Label(theme.rawValue, systemImage: "checkmark")
                                } else {
                                    Text(theme.rawValue)
                                }
                            }
                        }
                    } label: {
                        Text("Theme")
                        Image(systemName: "moonphase.last.quarter.inverse")
                    }
                    
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
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                }
                
            }
            .overlay(
                feedbackManager.feedbackMessage != nil ? FeedbackView(feedbackMessage: feedbackManager.feedbackMessage!).padding(.bottom, 100) : nil,
                alignment: .bottom
            )
            .animation(.easeInOut, value: feedbackManager.feedbackMessage)
            
        }
        .environmentObject(feedbackManager)
        
    }
    
}

#Preview {
    MainScreen()
}
