//
//  ToastWindow.swift
//
//
//  Created by Philippe Weidmann on 22.10.2023.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

class WindowSceneProviderView: UIView {
    private var currentWindow: UIWindow?
    private let title: String?
    private let icon: Image?
    private let onDisappear: () -> Void

    init(text: String?, icon: Image?, onDisappear: @escaping () -> Void) {
        title = text
        self.icon = icon
        self.onDisappear = onDisappear
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        guard let newWindow,
              let scene = newWindow.windowScene,
              currentWindow == nil
        else { return }
        currentWindow = ToastWindow(windowScene: scene, text: title, icon: icon, onDisappear: onDisappear)
    }
}

class ToastWindow: UIWindow {
    init(windowScene: UIWindowScene, text: String?, icon: Image?, onDisappear: @escaping () -> Void) {
        super.init(windowScene: windowScene)
        rootViewController = UIHostingController(rootView: ToastView(
            title: text,
            icon: icon,
            onDisappear: onDisappear
        ))
        windowLevel = .alert
        rootViewController?.view.backgroundColor = .clear
        makeKeyAndVisible()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#elseif canImport(AppKit)
import AppKit
import SwiftUI

class WindowSceneProviderView: NSView {
    private var currentWindow: NSWindow?
    private let title: String?
    private let icon: Image?
    private let onDisappear: () -> Void

    init(text: String?, icon: Image?, onDisappear: @escaping () -> Void) {
        title = text
        self.icon = icon
        self.onDisappear = onDisappear
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        guard let newWindow, let contentView = newWindow.contentView else { return }
        ToastPresenter.show(
            parentWindow: newWindow,
            parentView: contentView,
            text: title,
            icon: icon,
            onDisappear: onDisappear
        )
    }
}
#endif
