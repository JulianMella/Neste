//
//  SegmentedPicker.swift
//  Neste
//
//  Created by Julian on 08/04/2026.
//

import SwiftUI

struct SegmentedPicker: View {
    @Binding var selection: Int
    let items: [(String, String?)]

    @Namespace private var ns

    var body: some View {
        HStack(spacing: 2) {
            ForEach(items.indices, id: \.self) { i in
                let selected = selection == i

                Button {
                    withAnimation(.easeOut(duration: 0.25)) { selection = i }
                } label: {
                    Group {
                        if let icon = items[i].1 {
                            Label(items[i].0, systemImage: icon)
                        } else {
                            Text(items[i].0)
                        }
                    }
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(selected ? Color.primary : .gray)
                    .animation(.none, value: selection)
                    .frame(maxWidth: .infinity, minHeight: 28)
                    .contentShape(Capsule())
                }
                .buttonStyle(.borderless)
                .background {
                    if selected {
                        Capsule()
                            .fill(.white.opacity(0.15))
                            .matchedGeometryEffect(id: "sel", in: ns)
                    }
                }
            }
        }
        .padding(2.5)
        .background(Color.primary.opacity(0.08))
        .clipShape(Capsule())
    }
}
