//
//  FidgetView.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 14.11.24.
//

import SwiftUI

private enum ColorStyles: Int, CaseIterable {
    case red = 0
    case green
    case blue
    case yellow
    case purple
    case rainbow
    
    var color: Color {
        switch self {
        case .red: return Color.red
        case .blue: return Color.blue
        case .green: return Color.green
        case .yellow: return Color.yellow
        case .purple: return Color.purple
        case .rainbow: return Color.pink
        }
    }
}

enum AppTheme: String, Codable, Equatable, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { return rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
    
    var icon: Image {
        switch self {
        case .light: return Image(systemName: "sun.max.fill")
        case .dark: return Image(systemName: "moon.fill")
        case .system: return Image(systemName: "circle.lefthalf.filled")
        }
    }
}

struct StyleSettingsView<Model>: View where Model: FidgetViewModel {
    @StateObject var model: Model
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss

    private let rows = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: .spacingL) {
                
                // Background (Appearance)
                
                Group {
                    HStack {
                        VStack(alignment: .leading, spacing: .spacingS) {
                            Text("App Theme")
                                .headline3()
                                .multilineTextAlignment(.leading)
                            Text("Turn on dark mode, light mode or let the system decide")
                                .body1(color: .textSecondary)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    
                    HStack {
                        ForEach(AppTheme.allCases, id: \.rawValue) { theme in
                            ThemeSelectionItem(
                                theme: theme, 
                                selected: theme == settingsViewModel.selectedAppTheme
                            ) {
                                settingsViewModel.selectedAppTheme = theme
                            }
                        }
                    }
                }
                
                Divider()
                
                // Colors
                Group {
                    HStack {
                        Text("Color")
                            .headline3()
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    LazyVGrid(columns: rows) {
                        ForEach(ColorStyles.allCases, id: \.color) { colorStyle in
                            if colorStyle != .rainbow {
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                    .fill(colorStyle.color)
                                    .frame(height: 54)
                                    .onTapGesture {
                                        model.selectedColor = colorStyle.color
                                    }
                                    .opacity(model.selectedColor == colorStyle.color ? 1.0 : 0.3)
                            } else {
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                    .fill(    LinearGradient(
                                        gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(height: 54)
                                    .onTapGesture {
                                        model.selectedColor = nil
                                    }
                                    .opacity(model.selectedColor == nil ? 1.0 : 0.3)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .preferredColorScheme(settingsViewModel.selectedAppTheme.colorScheme)
            .padding(.spacingM)
            .padding(.top, .spacingL)
            .overlay(alignment: .topTrailing) {
                CloseIcon {
                    dismiss()
                }
                .padding(.spacingM)
            }
        }
    }
    
    
    private struct ThemeSelectionItem: View {
        var theme: AppTheme
        var selected: Bool
        var onClick: () -> Void

        @State private var touchAnimation: Bool = false

        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    theme.icon
                        .title3()
                        .scaledToFit()
                        .symbolEffect(.bounce, value: touchAnimation)
                    Text(theme.rawValue)
                        .padding(.top, .spacingM)
                }
                .subtitle2()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.spacingM)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.text, lineWidth: 1.5)
            )
            .opacity(selected ? 1.0 : 0.3)
            .onTapGesture {
                touchAnimation.toggle()
                onClick()
            }
        }
    }
}


#Preview {
    NavigationStack {
        Color.red
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                NavigationStack {
                    StyleSettingsView(model: FidgetViewModel())
                        .environmentObject(SettingsViewModel())
                }
                .presentationDetents([.fraction(0.5)])
                .presentationCornerRadius(.sheetRadius)
                .presentationDragIndicator(.visible)
                .presentationBackground(Material.regular)
            }
    }
}
