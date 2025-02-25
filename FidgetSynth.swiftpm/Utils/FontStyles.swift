//
//  FontStyles.swift
//  iOSStarterTemplate
//
//  Created by Philipp Ollmann on 16.11.22.
//

import Foundation
import SwiftUI

extension View {
    func customTextStyle(color: Color = .text, lineHeight: CGFloat, size: CGFloat, weight: Font.Weight, width: Font.Width = .standard, design: Font.Design? = nil) -> some View {
        return modifier(FontRegular(color: color, lineHeight: lineHeight, size: size, weight: weight, width: width, design: design))
    }

    // MARK: Title

    /// Size: 32 — Weight: Bold(700) - Width: Standard
    func title1(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 32, weight: .bold, width: width, design: design))
    }

    /// Size: 24 — Weight: Bold(700) - Width: Standard
    func title2(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 24, weight: .bold, width: width, design: design))
    }

    /// Size: 16 — Weight: Bold(700) - Width: Standard
    func title3(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 16, weight: .bold, width: width, design: design))
    }

    /// Size: 12 — Weight: Bold(700) - Width: Standard
    func title4(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 12, weight: .bold, width: width, design: design))
    }

    // MARK: Headline

    /// Size: 32 — Weight: Semibold(600)) - Width: Standard
    func headline1(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 32, weight: .semibold, width: width, design: design))
    }

    /// Size: 28 — Weight: Semibold(600)) - Width: Standard
    func headline1_2(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 28, weight: .semibold, width: width, design: design))
    }

    /// Size: 24 — Weight: Semibold(600)) - Width: Standard
    func headline2(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 24, weight: .semibold, width: width, design: design))
    }

    /// Size: 21 — Weight: Semibold(600)) - Width: Standard
    func headline2_3(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 21, weight: .semibold, width: width, design: design))
    }

    /// Size: 16 — Weight: Semibold(600)) - Width: Standard
    func headline3(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 16, weight: .semibold, width: width, design: design))
    }

    /// Size: 12 — Weight: Semibold(600)) - Width: Standard
    func headline4(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 12, weight: .semibold, width: width, design: design))
    }

    // MARK: Subtitle

    /// Size: 24 — Weight: Semibold(600) - Width: Standard
    func subtitle1(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 24, weight: .medium, width: width, design: design))
    }

    /// Size: 16 — Weight: Semibold(600) - Width: Standard
    func subtitle2(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 16, weight: .medium, width: width, design: design))
    }

    /// Size: 12 — Weight: Semibold(600) - Width: Standard
    func subtitle3(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 12, weight: .medium, width: width, design: design))
    }

    /// Size: 8 — Weight: Semibold(600) - Width: Standard
    func subtitle4(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 8, weight: .medium, width: width, design: design))
    }

    // MARK: Body

    /// Size: 16 — Weight: Semibold(600) - Width: Standard
    func body1(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 16, weight: .regular, width: width, design: design))
    }

    /// Size: 12 — Weight: Semibold(600) - Width: Standard
    func body2(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 12, weight: .regular, width: width, design: design))
    }

    /// Size: 10 — Weight: Semibold(600) - Width: Standard
    func body3(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 10, weight: .regular, width: width, design: design))
    }

    /// Size: 8 — Weight: Semibold(600) - Width: Standard
    func body4(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 8, weight: .regular, width: width, design: design))
    }

    // MARK: Special

    func specialNumber(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 64, weight: .bold, width: width, design: design))
    }

    func specialNumberImage(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .rounded) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 256, weight: .bold, width: width, design: design))
    }

    func specialShareText(color: Color = .text, width: Font.Width = .standard, design: Font.Design? = .default) -> some View {
        return modifier(FontRegular(color: color, lineHeight: 0, size: 14, weight: .regular, width: width, design: design))
    }
}

struct FontRegular: ViewModifier {
    let color: Color
    let lineHeight: CGFloat
    let size: CGFloat
    let weight: Font.Weight
    let width: Font.Width
    let design: Font.Design?

    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .lineSpacing(lineHeight - size)
            .font(.system(size: size, weight: weight, design: design))
            .fontWidth(width)
    }
}
