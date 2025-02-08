//
//  ToastView.swift
//
//
//  Created by Philippe Weidmann on 22.10.2023.
//

import SwiftUI

struct ToastView: View {
    @State private var isShowing = false

    let title: String?
    let icon: Image?
    let onDisappear: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                icon
                if let title {
                    Text(title)
                }
            }
            .font(.subheadline.weight(.medium))
            .padding(20)
            .background(Material.thin)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .scaleEffect(isShowing ? CGSize(width: 1, height: 1) : .zero)
            .padding(.bottom, 96)
        }
        .onAppear {
            guard !isShowing else { return }
            withAnimation(.bouncy.speed(3)) {
                #if canImport(UIKit)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                #endif
                isShowing = true
            }

            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)

                if #available(iOS 17.0, macOS 14.0, *) {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isShowing = false
                    } completion: {
                        onDisappear()
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isShowing = false
                    }

                    try await Task.sleep(nanoseconds: 150_000_000)
                    onDisappear()
                }
            }
        }
    }
}

#if canImport(UIKit)
struct WindowSceneProviderViewRepresentable: UIViewRepresentable {
    let title: String?
    let icon: Image?
    let onDisappear: () -> Void

    func makeUIView(context: Context) -> WindowSceneProviderView {
        return WindowSceneProviderView(text: title, icon: icon, onDisappear: onDisappear)
    }

    func updateUIView(_ view: WindowSceneProviderView, context: Context) {}
}

#elseif canImport(AppKit)

struct WindowSceneProviderViewRepresentable: NSViewRepresentable {
    let title: String?
    let icon: Image?
    let onDisappear: () -> Void

    func makeNSView(context: Context) -> WindowSceneProviderView {
        return WindowSceneProviderView(text: title, icon: icon, onDisappear: onDisappear)
    }

    func updateNSView(_ view: WindowSceneProviderView, context: Context) {}
}
#endif

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    @Previewable @State var isShowing = false

    VStack {
        Button("Show Toast") {
            isShowing.toggle()
        }
    }
    .frame(width: 400, height: 400)
    .background(Color.white)
    .toast(isPresented: $isShowing, title: "Toast", icon: Image(systemName: "checkmark.circle"))
}
