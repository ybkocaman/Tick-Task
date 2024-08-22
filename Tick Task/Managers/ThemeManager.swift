//
//  ThemeManager.swift
//  Tick Task
//
//  Created by Yusuf Burak on 22/08/2024.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"

    var id: String { self.rawValue }
}

class ThemeManager: ObservableObject {
    @Published var selectedTheme: Theme {
        didSet {
            applyTheme()
        }
    }
    
    init() {
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"), let theme = Theme(rawValue: savedTheme) {
            self.selectedTheme = theme
        } else {
            self.selectedTheme = .system
        }
        applyTheme()
    }
    
    private func applyTheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        switch selectedTheme {
        case .light:
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        case .dark:
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        case .system:
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
    }
}

