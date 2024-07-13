//
//  MainScreen.swift
//  Tick Task
//
//  Created by Yusuf Burak on 30/06/2024.
//

import SwiftUI
import UserNotifications

struct MainScreen: View {

    @State private var permissionGranted = false
    @StateObject private var feedbackManager = FeedbackManager()

    var body: some View {
                
        NavigationStack {
            
            ZStack {
                
                TaskListView()

                AddTaskButton()

            }
            
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
            .overlay(
                feedbackManager.feedbackMessage != nil ? FeedbackView(feedbackMessage: feedbackManager.feedbackMessage!).padding(.bottom, 100) : nil,
                alignment: .bottom
            )
            .animation(.easeInOut, value: feedbackManager.feedbackMessage)
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    permissionGranted = true
                }
            }
        }
        
        .environmentObject(feedbackManager)
    }
    
    private func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                permissionGranted = true
                print("permission granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        print("function called")
    }
    
}

#Preview {
    MainScreen()
}
