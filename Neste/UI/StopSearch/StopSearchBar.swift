//
//  StopSearchBar.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import SwiftUI

// TODO: Make search bar generalized for RouteSearch, make magnifying glass permanent, consider x button on write, search button unclickable and grey until person writes something, consider instant focus on enter view

struct StopSearchBar: View {
    @Environment(StopSearchViewModel.self) private var stopSearchViewModel
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
        HStack(spacing: 8) {
            Button {
                showStopSearch.toggle()
            } label: {
                Image(systemName: "chevron.left")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.primary)
                .frame(width: 32, height: 32)
                .background(Color.primary.opacity(0.08))
                .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            TextField(
                "􀊫 Search for your favorite stops",
                text: $autocompleteQuery
            )
            .textFieldStyle(.plain)
            .font(.headline.weight(.semibold))
            .focusEffectDisabled()
            .focused($isSearchFocused)
            .frame(maxWidth: .infinity, minHeight: 28)
            .padding(.horizontal, 12)
            .padding(.vertical, 2.5)
            .background(Color.primary.opacity(0.08))
            .clipShape(Capsule())
            .contentShape(Capsule())
            .onTapGesture {
                isSearchFocused = true
            }
            .onSubmit {
                Task {
                    isSearchFocused = false
                    await stopSearchViewModel.search(autocompleteQuery)
                }
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
    }
}
