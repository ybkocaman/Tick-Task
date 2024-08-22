//
//  PriorityBoxView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 09/07/2024.
//

import SwiftUI

struct PriorityBoxView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var priority: Int16
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Priority")
                .bold()
            Spacer()
            Picker("Priority", selection: $priority) {
                Text("High")
                    .tag(Int16(1))

                Text("Medium")
                    .tag(Int16(2))

                Text("Low")
                    .tag(Int16(3))
            }
            .tint(.white)
            .pickerStyle(.segmented)
        }
        .environment(\.colorScheme, .light)

        .foregroundStyle(.black)
        .padding(.horizontal)
        .padding(.vertical, 11)
        .background(getPriorityColor(priority: priority).opacity(0.5))
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .stroke(Color.black, lineWidth: 3)
        )
        .clipShape(.rect(cornerRadius: 15))
        
    }
    
    private func getPriorityColor(priority: Int16) -> Color {
        switch priority {
        case 1:
            return .red
        case 2:
            return .yellow
        default:
            return .blue
        }
    }
    
}

#Preview {
    struct Preview: View {
        @State var priority: Int16 = 2
        var body: some View {
            PriorityBoxView(priority: $priority)
        }
    }
    return Preview()
}
