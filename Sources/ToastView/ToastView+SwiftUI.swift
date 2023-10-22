//
//  ToastView+SwiftUI.swift
//
//
//  Created by Philippe Weidmann on 22.10.2023.
//

import SwiftUI

public extension View {
    func toast(isPresented: Binding<Bool>, title: String? = nil, icon: Image? = nil) -> some View {
        modifier(ToastViewModifier(isPresented: isPresented, title: title, icon: icon))
    }
}

struct ToastViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String?
    let icon: Image?

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    WindowSceneProviderViewRepresentable(title: title, icon: icon) {
                        isPresented = false
                    }
                }
            }
    }
}
