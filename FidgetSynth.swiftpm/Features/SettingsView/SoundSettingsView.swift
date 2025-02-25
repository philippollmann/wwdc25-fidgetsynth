//
//  FidgetView.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 14.11.24.
//

import SwiftUI

struct SoundSettingsView<Model>: View where Model: FidgetViewModel {
    @StateObject var model: Model
    @Environment(\.dismiss) private var dismiss
    
    private let waveforms = [
        ("Sine", ToneGenerator.WaveformType.sine),
        ("Square", ToneGenerator.WaveformType.square),
        ("Triangle", ToneGenerator.WaveformType.triangle),
        ("Sawtooth", ToneGenerator.WaveformType.sawtooth)
    ]
    
    private let rows_waveform = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let rows_effect = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
                VStack(spacing: 16) {
                    HStack {
                        Text("Waveform")
                            .headline3()
                        Spacer()
                    }
                    
                    LazyVGrid(columns: rows_waveform, spacing: 8) {
                        ForEach(ToneGenerator.WaveformType.allCases, id: \.rawValue) { waveform in
                            WaveformSelectionItem(waveform: waveform, selected: waveform == model.waveformType) {
                                model.waveformType = waveform
                            }
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Effect")
                            .headline3()
                        Spacer()
                    }
                    
                    LazyVGrid(columns: rows_effect, spacing: 8) {
                        ForEach(ToneGenerator.EffectType.allCases, id: \.rawValue) { effect in
                            if effect != .none {
                                EffectSelectionItem(effect: effect, selected: effect == model.effectType) {
                                    model.effectType = model.effectType == effect ? .none : effect
                                }
                            }
                        }
                    }
                    
                    Spacer()
            }
            .padding(.top, .spacingL)
            .padding(.horizontal, .spacingM)
            .overlay(alignment: .topTrailing) {
                CloseIcon {
                    dismiss()
                }
                .padding(.spacingM)
            }
        }
    }
}

private struct EffectSelectionItem: View {
    var effect: ToneGenerator.EffectType
    var selected: Bool
    var onClick: () -> Void
    
    @State private var touchAnimation: Bool = false
    
    var body: some View {
        Button {
            touchAnimation.toggle()
            onClick()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    effect.icon
                        .font(.headline.weight(.bold))
                        .symbolEffect(.bounce, value: touchAnimation)
                        .padding(.spacingM)
                    
                    Spacer()
                    Text(effect.rawValue)
                        .lineLimit(1)
                        .padding(.horizontal, .spacingS)
                        .padding(.bottom, .spacingM)
                }
                .subtitle2()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.text, lineWidth: 1.5)
            )
            .opacity(selected ? 1.0 : 0.3)
            .padding(1)
        }
    }
}


private struct WaveformSelectionItem: View {
    var waveform: ToneGenerator.WaveformType
    var selected: Bool
    var onClick: () -> Void
    
    @State private var touchAnimation: Bool = false
    
    var body: some View {
        Button {
            touchAnimation.toggle()
            onClick()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    waveform.icon
                        .font(.headline.weight(.bold))
                        .symbolEffect(.bounce, value: touchAnimation)
                    Spacer()
                    Text(waveform.rawValue)
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
            .padding(1)
        }
    }
}

#Preview {
    NavigationStack {
        Color.red
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                SoundSettingsView(model: FidgetViewModel())
                    .presentationDetents([.fraction(0.5)])
                    .presentationCornerRadius(.sheetRadius)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Material.regular)
            }
    }
    
}
