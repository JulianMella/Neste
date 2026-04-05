//
//  BrowseView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct BrowseView: View {
    @Binding var showAddFavorites: Bool
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
                        showAddFavorites.toggle()
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
        }
    }
}
