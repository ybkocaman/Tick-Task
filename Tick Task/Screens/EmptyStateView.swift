//
//  EmptyStateView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 12/07/2024.
//

import SwiftUI

struct EmptyStateView: View {
    @Environment(\.colorScheme) private var colorScheme

    var imageSystemName: String
    var header: String
    var message: String?
    
    var body: some View {
        
        VStack {
            
            Image(systemName: imageSystemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding(.bottom, 20)
            
            Text(header)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            
            if message != nil {
                Text(message!)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top, 100)
        
    }
}

#Preview {
    EmptyStateView(imageSystemName: "calendar.badge.clock", header: "No Previous Tasks")
}
