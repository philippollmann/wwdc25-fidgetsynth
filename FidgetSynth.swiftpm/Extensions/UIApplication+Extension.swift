//
//  UIApplication+Extension.swift
//  FidgetTouch
//
//  Created by Philipp Ollmann on 12.02.25.
//

import Foundation
import UIKit

extension UIApplication {
    func setAppearance(userInterfaceStyle: UIUserInterfaceStyle) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
    }
}
