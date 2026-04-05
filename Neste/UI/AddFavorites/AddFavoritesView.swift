//
//  AddFavoritesView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct AddFavoritesView: View {
    @State private var addFavoritesViewModel = AddFavoritesViewModel()
    @FocusState var isSearchFocused: Bool
    @Binding var showAddFavorites: Bool
    
    var body: some View {
        VStack {
            AddFavoritesSearchBar(addFavoritesViewModel: $addFavoritesViewModel, isSearchFocused: $isSearchFocused, showAddFavorites: $showAddFavorites)
            
            if (!addFavoritesViewModel.isLoading && addFavoritesViewModel.searchResults.isEmpty) {
                EmptyView()
            } else if (addFavoritesViewModel.isLoading) {
                PulsingDots()
            } else {
                AddFavoritesListView(searchResults: addFavoritesViewModel.searchResults)
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
