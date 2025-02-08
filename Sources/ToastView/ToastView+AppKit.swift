//
//  ToastView+AppKit.swift
//  ToastView
//
//  Created by Philippe Weidmann on 08.02.2025.
//

#if canImport(AppKit)
import AppKit
import OSLog
import SwiftUI

@MainActor
public class ToastPresenter {
    static let logger = Logger(subsystem: "ToastView", category: "ToastPresenter")

    public static func show(title: String? = nil, icon: NSImage? = nil, origin: NSView, onDisappear: (() -> Void)? = nil) {
        guard let window = origin.window,
              let contentView = window.contentView
        else {
            logger.warning("Trying to show ToastView from nil Window. Nothing will be shown.")
            return
        }

        var iconImage: Image?
        if let icon {
            iconImage = Image(nsImage: icon)
        }

        show(parentWindow: window, parentView: contentView, text: title, icon: iconImage, onDisappear: onDisappear)
    }

    static func show(
        parentWindow: NSWindow,
        parentView: NSView,
        text: String?,
        icon: Image?,
        onDisappear: (() -> Void)? = nil
    ) {
        var rootHostingViewController: NSHostingController<ToastView>?
        rootHostingViewController = NSHostingController(rootView: ToastView(
            title: text,
            icon: icon,
            onDisappear: {
                onDisappear?()
                rootHostingViewController?.view.removeFromSuperview()
            }
        ))

        guard let rootHostingViewController else { return }

        rootHostingViewController.view.frame = NSRect(origin: .zero, size: parentView.frame.size)
        rootHostingViewController.view.wantsLayer = true
        parentWindow.contentView?.addSubview(rootHostingViewController.view)
    }
}

#endif
