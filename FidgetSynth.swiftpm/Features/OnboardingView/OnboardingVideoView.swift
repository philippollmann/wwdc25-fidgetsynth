//
//  OnboardingView.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 15.02.25.
//

import SwiftUI
import AVKit

enum OnboardingViewType: Int, CaseIterable {
    case pitch = 1
    case modulation
    case effect
    
    var videoName: String {
        switch self {
        case .pitch: "pitch.mov"
        case .modulation: "modulation.mov"
        case .effect: "effect.mov"
        }
    }
    
    var color: Color {
        switch self {
        case .pitch: .purple
        case .modulation: .green
        case .effect: .blue
        }
    }
    
    var title: String {
        switch self {
        case .pitch: "Adjust the Pitch"
        case .modulation: "Modulate the Sound"
        case .effect: "Tilt for Effects"
        }
    }
    
    var text: String {
        switch self {
        case .pitch: "Slide up to raise the pitch and down to lower it. The higher you go, the sharper the tone—just like a theremin. Experiment to create dynamic melodies."
        case .modulation: "Slide left or right to adjust the modulation of the synth by changing the filter. This alters the tone and texture of your sound."
        case .effect: "Tilt your phone forward or backward to adjust the strength of the effect. Control the intensity of echo, reverb, and distortion to shape your sound."
        }
    }
    
    var buttonText: String {
        switch self {
        case .modulation, .pitch: "Continue"
        case .effect: "Let's rock 🤘"
        }
    }
}

struct OnboardingVideoView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let type: OnboardingViewType
    private var player: AVPlayer
    private var onClick: (() -> Void)
    
    private let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    init(type: OnboardingViewType, onClick: @escaping (() -> Void)) {
        self.onClick = onClick
        self.type = type
        self.player = AVPlayer(url: Bundle.main.url(forResource: type.videoName, withExtension: nil)!)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VideoPlayer(player: player)
                .aspectRatio(4/3, contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxHeight: UIScreen.main.bounds.width * (3/4))
            
            VStack(spacing: 8) {
                Text(type.title)
                    .title2()
                    .multilineTextAlignment(.center)
                
                Text(type.text)
                    .subtitle2(color: .textSecondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    impactMed.impactOccurred()
                    onClick()
                } label: {
                    Text(type.buttonText)
                        .headline3(color: .white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(type.color)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, .spacingL)
            .padding(.top, .spacingL)
        }
        .onAppear {
            player.play()
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                player.seek(to: .zero)
                player.play()
            }
        }
        .onDisappear {
            player.pause()
        }
    }
}

#Preview {
    NavigationStack {
        Color.red
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                OnboardingVideoView(type: .effect){}
                    .presentationDetents([.large])
                    .presentationCornerRadius(.sheetRadius)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Material.regular)
            }
    }
    
}
