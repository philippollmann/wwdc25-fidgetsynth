//
//  OnboardingView.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 15.02.25.
//

import SwiftUI

fileprivate enum OnbardingItem: CaseIterable {
    case play
    case visualize
    case color
    
    var title: String {
        switch self {
        case .play: "Inspired by the Theremin"
        case .visualize: "See Your Sound Come to Life"
        case .color: "Customize Your Experience"
        }
    }
    
    var text: String {
        switch self {
        case .play: "Create sounds by touching and swiping. Tilt your device to shape effects in real time."
        case .visualize: "Watch your music take form. Dots react to your touch, volume, and sound, creating dynamic, living visuals."
        case .color: "Personalize your sound with colors and waves that reflect your style. Make every note uniquely yours."
        }
    }
    
    var icon: Image {
        switch self {
        case .play:
            Image(systemName: "wand.and.stars")
        case .visualize: Image(systemName: "waveform.path.ecg")
        case .color: Image(systemName: "paintpalette")
        }
    }
    
    var iconColor: Color {
        switch self {
        case .play: .red
        case .visualize: .purple
        case .color: .blue
        }
    }
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var tabSelection: Int = 0
    
    private let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection) {
                VStack(alignment: .center) {
                    Text("Welcome to \nFidgetSynth - WWDC25")
                        .title1()
                        .multilineTextAlignment(.center)
                        .padding(.bottom, .spacingL)
                        .padding(.top, .spacingM)
                    
                    ForEach(OnbardingItem.allCases, id: \.title) { item in
                        OnboardingItemView(item: item)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            impactMed.impactOccurred()
                            tabSelection += 1
                        }
                    } label: {
                        Text("Continue")
                            .headline3(color: .white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.accent)
                            .cornerRadius(12)
                    }
                }
                .padding(.top, .spacingXL)
                .padding(.horizontal, .spacingL)
                .tag(0)
                
                
                ForEach(OnboardingViewType.allCases, id: \.videoName) { type in
                    OnboardingVideoView(type: type){
                        if type == .effect {
                            dismiss()
                        } else {
                            withAnimation {
                                tabSelection += 1
                            }
                        }
                    }
                    .tag(type.rawValue)
                }
            }
            .padding(.bottom, .spacingM)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .topTrailing) {
                CloseIcon {
                    dismiss()
                }
                .padding(.spacingM)
            }
        }
    }
}

fileprivate struct OnboardingItemView: View {
    var item: OnbardingItem
    
    var body: some View {
        HStack(alignment: .center) {
            item.icon
                .subtitle2(color: item.iconColor)
                .padding(.trailing, .spacingS)
                .bold()
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .subtitle2(color: .text)
                    .bold()
                Text(item.text)
                    .body1(color: .secondary)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, .spacingS)
    }
}

#Preview {
    NavigationStack {
        Color.red
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                OnboardingView()
                    .presentationDetents([.large])
                    .presentationCornerRadius(.sheetRadius)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Material.regular)
            }
    }
    
}
