//
//  ToneGenerator.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 14.11.24.
//

import AVFoundation
import SwiftUI
import CoreAudio

class ToneGenerator: ObservableObject {
    enum WaveformType: String, CaseIterable {
        case sine = "Sine"
        case triangle = "Triangle"
        case square = "Square"
        case sawtooth = "Sawtooth"
        
        var icon: Image {
            switch self {
            case .sine: Image(systemName: "alternatingcurrent")
            case .triangle: Image(systemName: "triangle.fill")
            case .square: Image(systemName: "rectangle.fill")
            case .sawtooth: Image(systemName: "bolt.horizontal.fill")
            }
        }
        
        var impact: Int {
            switch self {
            case .sine: 30
            case .triangle: 70
            case .square: 120
            case .sawtooth: 200
            }
        }
    }
    
    enum EffectType: String, CaseIterable {
        case echo = "Echo"
        case reverb = "Reverb"
        case distortion = "Distortion"
        case none = "None"
        
        var icon: Image {
            switch self {
            case .none: Image(systemName: "slash.circle")
            case .echo: Image(systemName: "arrow.triangle.2.circlepath")
            case .reverb: Image(systemName: "dot.radiowaves.right")
            case .distortion: Image(systemName: "waveform.path.ecg")
            }
        }
    }
    
    private var audioEngine: AVAudioEngine
    private var sourceNode: AVAudioSourceNode!
    private var filterNode: AVAudioUnitEQ
    private var phase: Float = 0.0
    
    // Remove flangerNode from properties
    private var delayNode: AVAudioUnitDelay!
    private var reverbNode: AVAudioUnitReverb!
    private var distortionNode: AVAudioUnitDistortion!
    
    @Published var frequency: Float
    @Published var amplitude: Float
    @Published var waveformType: WaveformType
    @Published var filterCutoff: Float {
        didSet {
            updateFilter()
        }
    }
    @Published var filterResonance: Float {
        didSet {
            updateFilter()
        }
    }
    
    @Published var currentEffect: EffectType = .none {
        didSet {
            updateAudioChain()
        }
    }
    var effectIntensity: Float = 0.0 {
        didSet {
            updateEffectIntensity()
        }
    }
    
    private let minFrequency: Float = 100.0
    private let maxFrequency: Float = 1000.0
    private let minFilterCutoff: Float = 20.0
    private let maxFilterCutoff: Float = 20000.0
    
    private func generateSample(phase: Float) -> Float {
        switch waveformType {
        case .sine:
            return sin(2.0 * Float.pi * phase)
        case .square:
            return phase < 0.5 ? 1.0 : -1.0
        case .triangle:
            return 1.0 - 4.0 * abs(phase - 0.5)
        case .sawtooth:
            return 2.0 * (phase - floor(phase + 0.5))
        }
    }
    
    init() {
        // Initialize published properties first
        self.frequency = 440.0
        self.amplitude = 0.0
        self.waveformType = .sawtooth
        self.filterCutoff = 20000.0
        self.filterResonance = 0.0
        
        // Initialize audio components
        self.audioEngine = AVAudioEngine()
        self.filterNode = AVAudioUnitEQ(numberOfBands: 1)
        
        // Initialize effect nodes
        self.delayNode = AVAudioUnitDelay()
        self.reverbNode = AVAudioUnitReverb()
        self.distortionNode = AVAudioUnitDistortion()
        
        // Create source node with format
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        
        // Create the source node after all other properties are initialized
        let node = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let buffer = ablPointer[0]
            let ptr = buffer.mData?.assumingMemoryBound(to: Float.self)
            
            let sampleRate = Float(44100)
            
            for frame in 0..<Int(frameCount) {
                self.phase += self.frequency / sampleRate
                if self.phase >= 1.0 {
                    self.phase -= 1.0
                }
                
                let sample = self.generateSample(phase: self.phase)
                ptr?[frame] = sample * self.amplitude
            }
            
            return noErr
        }
        
        self.sourceNode = node
        
        // Attach all nodes
        audioEngine.attach(sourceNode)
        audioEngine.attach(filterNode)
        audioEngine.attach(delayNode)
        audioEngine.attach(reverbNode)
        audioEngine.attach(distortionNode)
        
        // Modify the connection setup to only connect source -> filter -> main mixer initially
        audioEngine.connect(sourceNode, to: filterNode, format: format)
        audioEngine.connect(filterNode, to: audioEngine.mainMixerNode, format: format)
        
        // Configure initial states
        configureFilter()
        configureEffects()
        
        // Prepare and start engine
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    private func configureFilter() {
        let filter = filterNode.bands[0]
        filter.filterType = .lowPass
        filter.frequency = filterCutoff
        filter.bandwidth = 0.5
        filter.bypass = false
    }
    
    private func updateFilter() {
        let filter = filterNode.bands[0]
        filter.frequency = filterCutoff
        filter.gain = filterResonance * 12 // Convert 0-1 range to dB
    }
    
    private func configureEffects() {
        // Initialize effects with zero intensity
        delayNode.wetDryMix = 0
        reverbNode.wetDryMix = 0
        distortionNode.wetDryMix = 0
    }
    
    private func updateEffectIntensity() {
        // Reset all effects first
        delayNode.wetDryMix = 0
        reverbNode.wetDryMix = 0
        distortionNode.wetDryMix = 0
        
        // Apply only the current effect based on intensity
        switch currentEffect {
        case .none:
            break // No effect applied
        case .echo:
            delayNode.wetDryMix = 100 * effectIntensity
            delayNode.delayTime = 0.2
        case .reverb:
            reverbNode.wetDryMix = 100 * effectIntensity
        case .distortion:
            distortionNode.wetDryMix = 100 * effectIntensity
            distortionNode.preGain = 20 * effectIntensity
        }
    }
    
    func updatePitch(withVerticalTranslation translation: Float, initialTouchY: CGFloat) {
        let screenHeight = UIScreen.main.bounds.height
        let normalizedY = Float(initialTouchY) / Float(screenHeight)
        let baseFrequency = minFrequency + (maxFrequency - minFrequency) * (1 - normalizedY)
        
        let sensitivity: Float = 2.0
        let newFrequency = baseFrequency * pow(2, translation * sensitivity / 1000)
        frequency = min(max(newFrequency, minFrequency), maxFrequency)
    }
    
    func updateFilter(withHorizontalPosition x: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let normalizedX = Float(x) / Float(screenWidth)
        
        // Exponential scaling for filter sweep
        let logMin = log(minFilterCutoff)
        let logMax = log(maxFilterCutoff)
        filterCutoff = exp(logMin + (logMax - logMin) * normalizedX)
        
        // Update resonance
        filterResonance = (1.0 - normalizedX) * 0.7
    }
    
    func startTone() {
        if !audioEngine.isRunning {
            try? audioEngine.start()
        }
        amplitude = 0.5
    }
    
    func stopTone() {
        amplitude = 0.0
    }
    
    deinit {
        audioEngine.stop()
    }
    
    private func updateAudioChain() {
        // Stop the engine temporarily
        audioEngine.stop()
        
        // Remove all existing connections
        audioEngine.disconnectNodeOutput(filterNode)
        audioEngine.disconnectNodeOutput(delayNode)
        audioEngine.disconnectNodeOutput(reverbNode)
        audioEngine.disconnectNodeOutput(distortionNode)
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        
        // Reconnect based on current effect
        switch currentEffect {
        case .echo:
            audioEngine.connect(filterNode, to: delayNode, format: format)
            audioEngine.connect(delayNode, to: audioEngine.mainMixerNode, format: format)
        case .reverb:
            audioEngine.connect(filterNode, to: reverbNode, format: format)
            audioEngine.connect(reverbNode, to: audioEngine.mainMixerNode, format: format)
        case .distortion:
            audioEngine.connect(filterNode, to: distortionNode, format: format)
            audioEngine.connect(distortionNode, to: audioEngine.mainMixerNode, format: format)
        case .none:
            audioEngine.connect(filterNode, to: audioEngine.mainMixerNode, format: format)
        }
        
        // Restart the engine
        audioEngine.prepare()
        try? audioEngine.start()
        
        // Update effect intensity
        updateEffectIntensity()
    }
}
