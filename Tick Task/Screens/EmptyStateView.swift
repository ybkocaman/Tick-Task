//
//  EmptyStateView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 12/07/2024.
//

import SwiftUI

struct EmptyStateView: View {
    
    var imageSystemName: String
    var header: String
    var message: String?
    
    var body: some View {
        
        VStack {
            
            Image(systemName: imageSystemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            Text(header)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            if message != nil {
                Text(message!)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top, 100)
        
    }
}

#Preview {
    EmptyStateView(imageSystemName: "calendar.badge.clock", header: "No Previous Tasks")
}
