//
//  IconButton.swift
//  MissYou
//
//  Created by Philipp Ollmann on 17.07.24.
//

import SwiftUI

struct IconButton: View {
    var icon: Image
    var onClick: () -> Void

    @State private var animate: Bool = false

    var body: some View {
        Button {
            onClick()
            animate.toggle()
        } label: {
            icon
                .bold()
                .tint(Color.text)
                .frame(width: .spacing4XL, height: .spacing4XL)
                .background(Material.ultraThin)
                .clipShape(RoundedRectangle(cornerRadius: .buttonRadius))
                .symbolEffect(.bounce, value: animate)
        }
    }
}

#Preview("Dark") {
    IconButton(icon: Image(systemName: "heart.fill")) {}
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    IconButton(icon: Image(systemName: "heart.fill")) {}
        .preferredColorScheme(.light)
}
