import SwiftUI

extension Color {
    static func adaptive(light: Color, dark: Color) -> Color {
        return Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light) })
    }
    
    static let accent = adaptive(light: Color(hex: "#B38A00"), dark: Color(hex: "#FFD700"))
    static let accentSecondary = adaptive(light: Color(hex: "#8B6A20"), dark: Color(hex: "#C9A227"))
    
    static let background = adaptive(light: Color(hex: "#FFFFFF"), dark: Color(hex: "#121212"))
    static let backgroundSecondary = adaptive(light: Color(hex: "#F5F5F5"), dark: Color(hex: "#1E1E1E"))
    static let backgroundSheet = adaptive(light: Color(hex: "#F5F5F5"), dark: Color(hex: "#1C1C1C"))
    static let backgroundThird = adaptive(light: Color(hex: "#F0F0F0"), dark: Color(hex: "#242424"))
    
    static let darkGray = adaptive(light: Color(hex: "#A0A0A0"), dark: Color(hex: "#D1D1D1"))
    static let lightGray = adaptive(light: Color(hex: "#E0E0E0"), dark: Color(hex: "#3A3A3A"))
    
    static let listForeground = adaptive(light: Color(hex: "#F8F8F8"), dark: Color(hex: "#1A1A1A"))
    
    static let text = adaptive(light: Color(hex: "#000000"), dark: Color(hex: "#FFFFFF"))
    static let textSecondary = adaptive(light: Color(hex: "#808080"), dark: Color(hex: "#B3B3B3"))
}

// HEX to Color Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: Double
        switch hex.count {
        case 6:
            (a, r, g, b) = (1, Double((int >> 16) & 0xFF) / 255, Double((int >> 8) & 0xFF) / 255, Double(int & 0xFF) / 255)
        case 8:
            (a, r, g, b) = (Double((int >> 24) & 0xFF) / 255, Double((int >> 16) & 0xFF) / 255, Double((int >> 8) & 0xFF) / 255, Double(int & 0xFF) / 255)
        default:
            (a, r, g, b) = (1, 0, 0, 0)
        }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}




