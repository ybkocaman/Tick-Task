//
//  AppButton.swift
//  Tick Task
//
//  Created by Yusuf Burak on 09/07/2024.
//

import SwiftUI

struct AppButton: View {
    
    var title: String
    var systemName: String?
    var isFilledBackground: Bool
    var fontColor: Color
    var buttonColor: Color
    
    var body: some View {
        if isFilledBackground {
            HStack {
                if systemName != nil {
                    Image(systemName: systemName!)
                }
                Text(title)
            }
                .bold()
                .frame(maxWidth: .infinity)
                .foregroundStyle(fontColor)
                .padding(9)
                .background(buttonColor)
                .clipShape(Capsule())
        } else {
            HStack {
                Image(systemName: systemName ?? "")
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(fontColor)
            .padding(9)
            .overlay(
                Capsule()
                    .stroke(Color.red, lineWidth: 3)
            )
            .clipShape(Capsule())

        }

    }
    
}

#Preview {
    AppButton(title: "Delete Task", systemName: "trash", isFilledBackground: false, fontColor: .red, buttonColor: .blue)
}
