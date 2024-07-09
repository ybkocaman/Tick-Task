//
//  AddTaskButton.swift
//  Tick Task
//
//  Created by Yusuf Burak on 09/07/2024.
//

import SwiftUI

struct AddTaskButton: View {
    
    var body: some View {
        Text("Add Task")
            .bold()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .padding(9)
            .background(.blue)
            .clipShape(Capsule())
    }
}

#Preview {
    AddTaskButton()
}
