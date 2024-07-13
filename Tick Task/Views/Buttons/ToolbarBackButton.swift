//
//  ToolbarBackButton.swift
//  Tick Task
//
//  Created by Yusuf Burak on 13/07/2024.
//

import SwiftUI

struct ToolbarBackButton: View {
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
            Text("Back")
        }
        .bold()
        .foregroundStyle(.purple)
    }
}

#Preview {
    ToolbarBackButton()
}
