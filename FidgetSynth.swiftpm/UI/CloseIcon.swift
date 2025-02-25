//
//  CloseIcon.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 12.02.25.
//

import SwiftUI

struct CloseIcon: View {
    var onClick: () -> Void

    var body: some View {
        Button {
            onClick()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 12, height: 12)
                .body1(color: .textSecondary)
                .bold()
                .padding(.spacingS)
                .background(Material.regular)
                // .background(Color.background.opacity(0.2))
                .clipShape(Circle())
        }
    }
}

#Preview("Dark") {
    CloseIcon {}
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    CloseIcon {}
        .preferredColorScheme(.light)
}
