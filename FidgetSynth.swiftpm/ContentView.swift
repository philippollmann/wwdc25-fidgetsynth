import SwiftUI

struct ContentView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        FidgetView()
            .environmentObject(settingsViewModel)
            .preferredColorScheme(settingsViewModel.selectedAppTheme.colorScheme)
    }
}
