//
//  Dots.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 14.11.24.
//

import Foundation
import SwiftUI

struct Dot: Equatable {
    var x: CGFloat
    var y: CGFloat
    let originX: CGFloat
    let originY: CGFloat
    var vx: CGFloat = 0
    var vy: CGFloat = 0
    var color: Color = .red
}
