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
    @FocusState var focusedField: Field?

    enum Field {
        case name, description
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Task Name")
                .bold()
            TextField("Enter Task Name Here...", text: $name)
                .padding(8)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 10))
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .description
                }
            
            Divider()
                .padding(.vertical, 10)
            
            Text("Task Description")
                .bold()
            TextField("Enter Task Description Here...", text: $taskDescription)
                .padding(8)
                .tint(.gray)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 10))
                .focused($focusedField, equals: .description)
                .submitLabel(.done)
        }
        .environment(\.colorScheme, .light)
        
        .onTapGesture {
            focusedField = nil
        }
        .padding()
        .background(Color("BoxBackground"))
        .foregroundStyle(.black)
        .overlay(
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .stroke(Color.black, lineWidth: 3)
        )
        .clipShape(.rect(cornerRadius: 15))
        .onAppear {
            if name.isEmpty {
                DispatchQueue.main.async {
                    focusedField = .name
                }
            }
        }
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
