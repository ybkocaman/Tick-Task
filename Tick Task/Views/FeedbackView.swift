//
//  FeedbackView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 12/07/2024.
//

import SwiftUI

struct FeedbackView: View {
    
    var feedbackMessage: String
    
    var body: some View {
        Text(feedbackMessage)
            .padding()
            .background(Color.black)
            .foregroundStyle(.white)
            .bold()
            .clipShape(Capsule())
    }
}

#Preview {
    FeedbackView(feedbackMessage: "Successfull")
}
