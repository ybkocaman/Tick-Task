//
//  TimeBoxView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 09/07/2024.
//

import SwiftUI

struct TimeBoxView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<Task>
    
    @State private var dueDate = Date()
    @State private var isDueTime = false
    @State private var dueTime: Date? = Date()
    
    var body: some View {
        VStack {
            DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                .background(Color.gray.opacity(0))
                .padding(.top, 5)
            Divider()
                .padding(.vertical, 5)
            Toggle("Is due time?", isOn: $isDueTime)
            if isDueTime {
                DatePicker("Due Time", selection: Binding(
                    get: { dueTime ?? Date() },
                    set: { dueTime = $0 }
                ), displayedComponents: .hourAndMinute)
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
    TimeBoxView()
}
