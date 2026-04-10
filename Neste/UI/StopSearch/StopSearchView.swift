//
//  StopSearchView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct StopSearchView: View {
    @Environment(StopSearchViewModel.self) private var stopSearchViewModel
    @FocusState var isSearchFocused: Bool
    @Binding var showStopSearch: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            StopSearchBar(isSearchFocused: $isSearchFocused, showStopSearch: $showStopSearch)
            
            if (!stopSearchViewModel.isLoading && stopSearchViewModel.searchResults.isEmpty) {
                EmptyView()
            } else if (stopSearchViewModel.isLoading) {
                PulsingDots()
                    .padding(.top, 16)
            } else {
                StopSearchList(searchResults: stopSearchViewModel.searchResults)
                    .padding(.top, 16)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isSearchFocused = false
        }
    }
}
