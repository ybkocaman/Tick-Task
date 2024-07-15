//
//  AddTaskButton.swift
//  Tick Task
//
//  Created by Yusuf Burak on 13/07/2024.
//

import SwiftUI

struct AddTaskButton: View {
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink {
                    AddTaskView()
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundStyle(.black)
                        .padding()
                        .background(Color.yellow.opacity(0.3))
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.black, lineWidth: 3)
                        }
                        .padding(30)
                }
            }
        }
    }
}

#Preview {
    AddTaskButton()
}
