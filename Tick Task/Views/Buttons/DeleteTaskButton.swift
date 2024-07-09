//
//  DeleteTaskButton.swift
//  Tick Task
//
//  Created by Yusuf Burak on 09/07/2024.
//

import SwiftUI

struct DeleteTaskButton: View {
    
    var body: some View {
    
        HStack {
            Image(systemName: "trash")
            Text("Delete Task")
        }
        .frame(maxWidth: .infinity)

        .foregroundStyle(.red)
        .padding(9)
        .overlay(
            Capsule()
                .stroke(Color.red, lineWidth: 3)
        )
        .clipShape(Capsule())
    }
}

#Preview {
    DeleteTaskButton()
}
