//
//  ContentView.swift
//  Neste
//
//  Created by Julian on 01/04/2026.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                SegmentedPicker(
                    selection: $selectedTab,
                    items: [
                        ("Favorites", "star"),
                        ("Near you", "location"),
                        ("Plan route", "point.topleft.down.to.point.bottomright.filled.curvepath")
                    ]
                )

                if selectedTab == 0 {
                    Button {
                        // add favorite action
                    } label: {
                        Image(systemName: "plus")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(.white.opacity(0.08)))
                    }
                    .buttonStyle(.plain)
                }
            }
            .animation(.easeOut(duration: 0.2), value: selectedTab)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Group {
                switch selectedTab {
                case 0: FavoriteStopsListView()
                case 1: Text("Near you")
                case 2: Text("Plan route")
                default: EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 450, minHeight: 400)
    }
}

struct SegmentedPicker: View {
    @Binding var selection: Int
    let items: [(String, String)]

    @Namespace private var ns

    var body: some View {
        HStack(spacing: 2) {
            ForEach(items.indices, id: \.self) { i in
                let selected = selection == i

                Button {
                    withAnimation(.easeOut(duration: 0.25)) { selection = i }
                } label: {
                    Label(items[i].0, systemImage: items[i].1)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(selected ? .white : .gray)
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
        .background(.white.opacity(0.08))
        .clipShape(Capsule())
        .fixedSize(horizontal: false, vertical: true)
    }
}
