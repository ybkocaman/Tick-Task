//
//  CompletionButton.swift
//  Tick Task
//
//  Created by Yusuf Burak on 09/07/2024.
//

import SwiftUI

struct CompletionButton: View {
    
    var isCompleted: Bool
    
    var body: some View {
        
            HStack {
                Image(systemName: isCompleted ? "square" : "checkmark.square")
                Text(isCompleted ? "Mark Uncompleted" : "Mark Completed")
            }
            .frame(maxWidth: .infinity)
            .bold()
            .foregroundStyle(.white)
            .padding(9)
            .background(isCompleted ? .black : .green)
            .clipShape(Capsule())
        }
        
}

#Preview {
    CompletionButton(isCompleted: true)
}
