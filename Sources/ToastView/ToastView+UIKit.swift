//
//  ToastView+UIKit.swift
//
//
//  Created by Philippe Weidmann on 22.10.2023.
//

import OSLog
import SwiftUI
import UIKit

public class ToastPresenter {
    static let logger = Logger(subsystem: "ToastView", category: "ToastPresenter")

    static var currentToastWindow: ToastWindow?

    public static func show(title: String? = nil, icon: UIImage? = nil, origin: UIView, onDisappear: (() -> Void)? = nil) {
        guard let windowScene = origin.window?.windowScene else {
            logger.warning("Trying to show ToastView from nil windowScene. Nothing will be shown.")
            return
        }

        var iconImage: Image?
        if let icon {
            iconImage = Image(uiImage: icon)
        }

        currentToastWindow = ToastWindow(
            windowScene: windowScene,
            text: title,
            icon: iconImage,
            onDisappear: onDisappear ?? {}
        )
    }
}

@available(iOS 17.0, *)
#Preview(traits: .defaultLayout) {
    var button: UIButton!
    button = UIButton(type: .system, primaryAction: UIAction(title: "Show Toast", handler: { _ in
        ToastPresenter.show(title: "Toast", icon: UIImage(systemName: "checkmark.circle"), origin: button)
    }))
    return button
}
