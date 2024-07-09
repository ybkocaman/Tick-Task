//
//  TaskDateAndTimeBoxView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 09/07/2024.
//

import SwiftUI

struct TaskDateAndTimeBoxView: View {
    
    @Binding var dueDate: Date
    @Binding var isDueTime: Bool
    @Binding var dueTime: Date?
    
    var body: some View {
        
        VStack {
            DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                .background(Color.gray.opacity(0))
                .padding(.top, 5)
            Divider()
                .padding(.vertical, 5)
            Toggle("Has Due Time", isOn: $isDueTime)
                .padding(.bottom, 5)
            if isDueTime {
                Divider()
                
                DatePicker("Due Time", selection: Binding(
                    get: { dueTime ?? Date() },
                    set: { dueTime = $0 }
                ), displayedComponents: .hourAndMinute)
                .onAppear {
                    UIDatePicker.appearance().minuteInterval = 15
                }
                .padding(.vertical, 5)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .overlay(
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .stroke(Color.black, lineWidth: 3)
        )
        .clipShape(.rect(cornerRadius: 15))
        
    }
}

#Preview {
    struct Preview: View {
        @State var dueDate: Date = Date()
        @State var isDueTime: Bool = false
        @State var dueTime: Date? = Date()
        var body: some View {
            TaskDateAndTimeBoxView(dueDate: $dueDate, isDueTime: $isDueTime, dueTime: $dueTime)
        }
    }
    return Preview()
}
