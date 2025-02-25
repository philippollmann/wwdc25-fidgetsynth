//
//  FidgetViewModel.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 14.11.24.
//


import SwiftUI
import Combine
import AVFoundation
import CoreMotion
import TipKit

@MainActor
class FidgetViewModel: ObservableObject {
    
    // dots
    @Published var dots: [Dot]
    @Published var touchLocation: CGPoint = CGPoint(x: -Int.max, y: -Int.max)
    @Published var dotSpacing: CGFloat = 16
    
    
    // tips
    let styleTip = StyleTip()
    let soundTip = SoundTip()
    
    // settings
    @Published var showOnboarding: Bool = true {
        didSet {
            if !showOnboarding {
                StyleTip.isEnabled = true
                SoundTip.isEnabled = true
            }
        }
    }
    
    // sheets
    @Published var showSoundSettings: Bool = false
    @Published var showStyleSettings: Bool = false
    @Published var dotLaziness: CGFloat = 20
    @Published var touchImpact: CGFloat = 100
    @Published var dotSize: CGFloat = 3
    
    // styles
    @Published var selectedColor: Color? = .red
    
    // sound properties
    @Published var waveformType: ToneGenerator.WaveformType = .sine
    @Published var effectType: ToneGenerator.EffectType = .echo
    
    var toneGenerator: ToneGenerator
    
    private var cancellables: Set<AnyCancellable> = []
    private let updateSubject = PassthroughSubject<Void, Never>()
    
    private let motionManager = CMMotionManager()
    @Published var effectIntensity: Float = 0.0
    
    init(toneGenerator: ToneGenerator = ToneGenerator()) {
        self.toneGenerator = toneGenerator
        dots = []
        setupUpdateTimer()
        setupWaveformObserver()
        setupEffectObserver()
        startMotionUpdates()
    }
    
    private func setupUpdateTimer() {
        Timer.publish(every: 1/120, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateSubject.send()
            }
            .store(in: &cancellables)
        
        updateSubject
            .collect(.byTime(DispatchQueue.main, .milliseconds(16)))
            .sink { [weak self] _ in
                self?.updateDots()
            }
            .store(in: &cancellables)
    }
    
    private func setupWaveformObserver() {
        $waveformType
            .sink { [weak self] waveform in
                self?.toneGenerator.waveformType = waveform
                self?.touchImpact = CGFloat(waveform.impact)
            }
            .store(in: &cancellables)
    }
    
    private func setupEffectObserver() {
        $effectType
            .sink { [weak self] effect in
                self?.toneGenerator.currentEffect = effect
            }
            .store(in: &cancellables)
        
        $effectIntensity
            .sink { [weak self] intensity in
                self?.toneGenerator.effectIntensity = intensity
            }
            .store(in: &cancellables)
    }
    
    private func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                guard let motion = motion, let self = self else { return }
                
                // Get pitch (forward/backward tilt) in degrees
                let pitch = motion.attitude.pitch * (180 / .pi)
                
                // Convert pitch to effect intensity (0 to 1)
                // Now: Normal position (0°) = max effect
                // Forward tilt (45°) = no effect
                let normalizedPitch = max(0, min(1, Float(pitch) / 45.0))
                self.effectIntensity = 1.0 - normalizedPitch  // Inverted the effect
            }
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func initializeDots(in size: CGSize) {
        let rows = Int(size.height / dotSpacing)
        let columns = Int(size.width / dotSpacing)
        dots = (0..<rows).flatMap { row in
            (0..<columns).map { column in
                let x = CGFloat(column) * dotSpacing
                let y = CGFloat(row) * dotSpacing
                return Dot(x: x, y: y, originX: x, originY: y)
            }
        }
    }
    
    func updateDots() {
        let touchBoundingSizeSquared = touchImpact * touchImpact
        // Map dotLaziness from 0-100 to 0.1-5.0 range
        let mappedLaziness = 0.1 + (dotLaziness / 100) * 4.9
        // Calculate dynamic laziness with more dramatic effect (0.1 to mappedLaziness)
        let dynamicLaziness = 0.1 + (mappedLaziness - 0.1) * (1.0 - CGFloat(effectIntensity))
        
        dots = dots.map { dot in
            var updatedDot = dot
            let dx = touchLocation.x - updatedDot.x
            let dy = touchLocation.y - updatedDot.y
            let distanceSquared = dx*dx + dy*dy
            
            if distanceSquared < touchBoundingSizeSquared {
                let distance = sqrt(distanceSquared)
                let force = (touchImpact - distance) / touchImpact
                let angle = atan2(dy, dx)
                let targetX = updatedDot.x - cos(angle) * force * 20
                let targetY = updatedDot.y - sin(angle) * force * 20
                
                updatedDot.vx += (targetX - updatedDot.x) * dynamicLaziness
                updatedDot.vy += (targetY - updatedDot.y) * dynamicLaziness
            }
            
            updatedDot.vx *= 0.9
            updatedDot.vy *= 0.9
            
            updatedDot.x += updatedDot.vx
            updatedDot.y += updatedDot.vy
            
            let dx2 = updatedDot.originX - updatedDot.x
            let dy2 = updatedDot.originY - updatedDot.y
            let distance2Squared = dx2*dx2 + dy2*dy2
            
            if distance2Squared > 1 {
                updatedDot.x += dx2 * 0.03
                updatedDot.y += dy2 * 0.03
            }
            
            return updatedDot
        }
    }
}

struct StyleTip: Tip {
    
    @Parameter static var isEnabled: Bool = false
    
    var title: Text {
        Text("Customize Visual Style")
    }
    
    var message: Text? {
        Text("Change theme and color of the visual effects.")
    }
    
    var rules: [Rule] {
        #Rule(Self.$isEnabled) { isEnabled in
            isEnabled // Only show when isEnabled is true
        }
    }
}

struct SoundTip: Tip {
    
    @Parameter static var isEnabled: Bool = false
    
    var title: Text {
        Text("Sound Settings")
    }
    
    var message: Text? {
        Text("Adjust the sound waveform and effect type.")
    }
    
    var rules: [Rule] {
        #Rule(Self.$isEnabled) { isEnabled in
            isEnabled // Only show when isEnabled is true
        }
    }
}
