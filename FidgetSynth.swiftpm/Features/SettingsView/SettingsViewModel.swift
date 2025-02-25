import SwiftUI
import Foundation


class SettingsViewModel: ObservableObject {
    @Published var selectedAppTheme: AppTheme = .dark {
        didSet { applyAppThemeSettings() }
    }

    
    private func applyAppThemeSettings() {
        Task {
            //await UIApplication.shared.setAppearance(userInterfaceStyle: selectedAppTheme)
        }
    }
}
