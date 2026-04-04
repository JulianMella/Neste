//
//  AddFavoritesSearchBar.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import SwiftUI

struct AddFavoritesSearchBar: View {
    @Binding var addFavoritesViewModel: AddFavoritesViewModel
    @FocusState.Binding var isSearchFocused: Bool
    @Binding var showAddFavorites: Bool
    
    @State var autocompleteQuery: String = ""
    
    var emptySearchField: Bool {
        if autocompleteQuery == "" {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                ZStack {
                    TextField(
                        "􀊫 Search for your favorite stops",
                        text: $autocompleteQuery
                    )
                    .focusEffectDisabled()
                    .focused($isSearchFocused)
                    .textFieldStyle(.plain)
                    .font(.caption2.weight(.semibold))
                    .onSubmit {
                        Task {
                            await addFavoritesViewModel.search(autocompleteQuery)
                            isSearchFocused = false
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 28)
                .padding(.horizontal, 12)
                .padding(.vertical, 2.5)
                .background(Capsule().fill(.white.opacity(0.08)))
                .pointerStyle(.horizontalText)
                .onTapGesture {
                    isSearchFocused = true
                }
                
                Button {
                    emptySearchField ? showAddFavorites.toggle() : showAddFavorites.toggle()
                } label: {
                    Image(
                        systemName: emptySearchField ? "xmark" : "magnifyingglass"
                    )
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        emptySearchField ? Circle().fill(.white.opacity(0.08)) : Circle().fill(.blue)
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
    }
}

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
        .padding(.bottom, 12)
    }
}
