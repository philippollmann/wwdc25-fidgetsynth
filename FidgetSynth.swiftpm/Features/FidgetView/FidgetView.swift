//
//  FidgetView.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 14.11.24.
//

import SwiftUI
import AVFoundation
import TipKit

struct FidgetView: View {
    @StateObject private var model = FidgetViewModel()
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                dotCanvas
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                model.touchLocation = value.location
                                
                                model.toneGenerator.startTone()
                                model.toneGenerator.updatePitch(withVerticalTranslation: Float(-value.translation.height), initialTouchY: value.location.y)
                                model.toneGenerator.updateFilter(withHorizontalPosition: value.location.x)
                            }
                            .onEnded { _ in
                                model.touchLocation = CGPoint(x: -Int.max, y: -Int.max)
                                model.toneGenerator.stopTone()
                            }
                    )
                    .onAppear {
                        model.initializeDots(in: CGSize(width: proxy.size.width + 20, height: proxy.size.height + 20))
                    }
                    .onChange(of: proxy.size) {
                        model.initializeDots(in: CGSize(width: proxy.size.width + 20, height: proxy.size.height + 20))
                    }
                    .sensoryFeedback(.impact, trigger: model.touchLocation)
            }
            .onReceive(AVAudioSession.sharedInstance().publisher(for: \.outputVolume)) { volume in
                model.dotSize = CGFloat(1 + (volume * 12)) // Scale from 1 to 10
            }
            .background(Color.background)
            .ignoresSafeArea(.all)
            .overlay(alignment: .top) {
                HStack {
                    VStack {
                        Text("Pitch")
                            .fontWeight(.bold)
                        Text("\(model.toneGenerator.frequency, specifier: "%4.0f") Hz")
                            .monospacedDigit()
                    }
                    
                    VStack {
                        Text(model.effectType.rawValue)
                            .fontWeight(.bold)
                        Text("\(model.effectIntensity * 100, specifier: "%3.0f") %")
                            .monospacedDigit()
                    }
                }
                .fontDesign(.rounded)
                .padding()
                .background(Color.background)
            }
            .overlay(alignment: .topTrailing){
                IconButton(icon: Image(systemName: "info")) {
                    model.showOnboarding = true
                }
                .frame(width: CGFloat.spacingXL, height: CGFloat.spacingXL)
                .cornerRadius(CGFloat.spacingM)
                .padding(.spacingM)
                
            }
        }
        .sheet(isPresented: $model.showOnboarding) {
            OnboardingView()
                .presentationDetents([.large])
                .presentationBackground(Material.regular)
                .presentationCornerRadius(.sheetRadius)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $model.showSoundSettings) {
            SoundSettingsView(model: model)
                .presentationDetents([.fraction(0.6), .large])
                .presentationBackground(Material.regular)
                .presentationCornerRadius(.sheetRadius)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $model.showStyleSettings) {
            StyleSettingsView(model: model)
                .presentationDetents([.fraction(0.6), .large])
                .presentationBackground(Material.regular)
                .presentationCornerRadius(.sheetRadius)
                .presentationDragIndicator(.visible)
                .environmentObject(settingsViewModel)
        }
        .overlay(alignment: .bottomLeading) {
            HStack {
                IconButton(icon: Image(systemName: "paintbrush.fill")) {
                    model.styleTip.invalidate(reason: .actionPerformed)
                    model.showStyleSettings = true
                }
                .popoverTip(model.styleTip, arrowEdge: .top)
                
                Spacer()
                
                IconButton(icon: Image(systemName: "music.quarternote.3")) {
                    model.soundTip.invalidate(reason: .actionPerformed)
                    model.showSoundSettings = true
                }
                .popoverTip(model.soundTip, arrowEdge: .top)
            }
            .padding(.spacingM)
        }
    }
    
    @ViewBuilder
    private var dotCanvas: some View {
        Canvas { context, size in
            for dot in model.dots {
                let color = model.selectedColor ?? Color(
                    hue: Double(dot.x + dot.y).truncatingRemainder(dividingBy: 100) / 100,
                    saturation: 1,
                    brightness: 1
                )
                
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: dot.x - model.dotSize/2,
                        y: dot.y - model.dotSize/2,
                        width: model.dotSize,
                        height: model.dotSize
                    )),
                    with: .color(color)
                )
            }
        }
    }
}


#Preview("Light") {
    FidgetView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    FidgetView()
        .preferredColorScheme(.dark)
}
