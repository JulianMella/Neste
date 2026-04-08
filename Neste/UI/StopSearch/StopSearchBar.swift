//
//  StopSearchBar.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import SwiftUI

struct StopSearchBar: View {
    @Binding var stopSearchViewModel: StopSearchViewModel
    @FocusState.Binding var isSearchFocused: Bool
    @Binding var showStopSearch: Bool
    
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
                Button {
                    showStopSearch.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(.white.opacity(0.08))
                    .clipShape(Circle())
                }
                .buttonStyle(.plain)
                ZStack {
                    TextField(
                        "􀊫 Search for your favorite stops",
                        text: $autocompleteQuery
                    )
                    .focusEffectDisabled()
                    .focused($isSearchFocused)
                    .textFieldStyle(.plain)
                    .font(.headline.weight(.semibold))
                    .onSubmit {
                        Task {
                            isSearchFocused = false
                            await stopSearchViewModel.search(autocompleteQuery)
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 28)
                .padding(.horizontal, 12)
                .padding(.vertical, 2.5)
                .background(.white.opacity(0.08))
                .clipShape(Capsule())
                .pointerStyle(.horizontalText)
                .onTapGesture {
                    isSearchFocused = true
                }
                
                Button {
                    Task {
                        isSearchFocused = false
                        await stopSearchViewModel.search(autocompleteQuery)
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(.blue)
                    .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
    }
}
