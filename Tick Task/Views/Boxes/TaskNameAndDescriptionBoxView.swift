//
//  TaskNameAndDescriptionBoxView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 09/07/2024.
//

import SwiftUI

struct TaskNameAndDescriptionBoxView: View {
    
    @Binding var name: String
    @Binding var taskDescription: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Task Name")
                .bold()
            TextField("Enter Task Name Here...", text: $name)
                .padding(10)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 10))
            Divider()
                .padding(.vertical, 10)
            Text("Task Description")
                .bold()
            TextField("Enter Task Description Here...", text: $taskDescription)
                .padding(10)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 10))
        }
        .padding()
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
        @State var name = "Task"
        @State var description = "Description"
        var body: some View {
            TaskNameAndDescriptionBoxView(name: $name, taskDescription: $description)
        }
    }

    return Preview()
}
