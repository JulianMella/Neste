//
//  StopSearchView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct StopSearchView: View {
    @State private var stopSearchViewModel = StopSearchViewModel()
    @FocusState var isSearchFocused: Bool
    @Binding var showStopSearch: Bool
    
    var body: some View {
        VStack {
            StopSearchBar(stopSearchViewModel: $stopSearchViewModel, isSearchFocused: $isSearchFocused, showStopSearch: $showStopSearch)
            
            if (!stopSearchViewModel.isLoading && stopSearchViewModel.searchResults.isEmpty) {
                EmptyView()
            } else if (stopSearchViewModel.isLoading) {
                PulsingDots()
            } else {
                StopSearchList(searchResults: stopSearchViewModel.searchResults)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isSearchFocused = false
        }
    }
}
