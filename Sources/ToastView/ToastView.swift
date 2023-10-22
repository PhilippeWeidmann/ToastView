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
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                isShowing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if #available(iOS 17.0, *) {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isShowing = false
                    } completion: {
                        onDisappear()
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isShowing = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        onDisappear()
                    }
                }
            }
        }
    }
}

struct WindowSceneProviderViewRepresentable: UIViewRepresentable {
    let title: String?
    let icon: Image?
    let onDisappear: () -> Void

    func makeUIView(context: Context) -> WindowSceneProviderView {
        return WindowSceneProviderView(text: title, icon: icon, onDisappear: onDisappear)
    }

    func updateUIView(_ uiView: WindowSceneProviderView, context: Context) {}
}

#Preview {
    struct PreviewWrapper: View {
        @State var isShowing = false

        var body: some View {
            VStack {
                Spacer()
                Button("Show Toast") {
                    isShowing.toggle()
                }
            }
            .toast(isPresented: $isShowing, title: "Toast", icon: Image(systemName: "checkmark.circle"))
        }
    }
    return PreviewWrapper()
}
