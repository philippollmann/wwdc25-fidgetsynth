//
//  ListSection.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 14.11.24.
//

import SwiftUI


struct ListSection<Content>: View where Content: View {
    var title: String? = nil
    var caption: String? = nil
    @ViewBuilder let content: Content

    var body: some View {
        VStack {
            if let title {
                ListSectionHeader(title: title)
            }

            content
                .padding(.spacingM)
                .background(Material.ultraThin.opacity(0.5))
                .background(Color.text.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: .spacingXL))

            if let caption {
                HStack {
                    Text(caption)
                        .body2(color: .textSecondary)
                    Spacer()
                }
                .padding(.horizontal, .spacingM)
            }
        }
        .padding(.top, .spacingM)
        .padding(.horizontal, .spacingM)
    }
}

struct ListSectionHeader: View {
    var title: String

    var body: some View {
        HStack {
            Text(title)
                .headline3(color: Color.textSecondary)
            Spacer()
        }
        .padding(.horizontal, .spacingM)
    }
}

// MARK: Previews
#Preview("Dark") {
    ListSection(title: "Test", caption: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.") {
        Text("Test")
    }
    .preferredColorScheme(.dark)
}

#Preview("Light") {
    ListSection(title: "Test",
                caption: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
    {
        Text("Test")
    }
    .preferredColorScheme(.light)
}

