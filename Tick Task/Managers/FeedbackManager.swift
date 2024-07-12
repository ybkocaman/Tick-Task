//
//  FeedbackManager.swift
//  Tick Task
//
//  Created by Yusuf Burak on 12/07/2024.
//

import Foundation

class FeedbackManager: ObservableObject {
    
    @Published var feedbackMessage: String?
    
    func showFeedback(message: String) {
        feedbackMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.feedbackMessage = nil
        }
    }
    
}
