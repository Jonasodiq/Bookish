//
//  ButtonModifiers.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-27.
//

import SwiftUI

// Primär-knappmodifierare
struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffectOnPress()
    }
}

// Sekundär-knappmodifierare
struct SecondaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.3))
            .foregroundColor(.black)
            .cornerRadius(10)
            .scaleEffectOnPress()
    }
}

// Extension för enklare användning
extension View {
    func primaryButton() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
    
    func secondaryButton() -> some View {
        self.modifier(SecondaryButtonModifier())
    }
}

// Liten extension för "tryck-animering"
extension View {
    func scaleEffectOnPress() -> some View {
        self.modifier(ScaleButtonEffect())
    }
}

struct ScaleButtonEffect: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}



