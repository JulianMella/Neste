//
//  PulsingDots.swift
//  Neste
//
//  Created by Julian on 08/04/2026.
//

import SwiftUI

struct PulsingDots: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .frame(width: 10, height: 10)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear { isAnimating = true }
    }
}
