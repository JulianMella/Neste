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
            
            if (!addFavoritesViewModel.isLoading && addFavoritesViewModel.geocoderResults.isEmpty) {
                EmptyView()
            } else if (addFavoritesViewModel.isLoading) {
                PulsingDots()
            } else {
                Text("Search Results!")
                ForEach(addFavoritesViewModel.geocoderResults, id: \.self) { geocoderStop in
                    Text(geocoderStop.id)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isSearchFocused = false
        }
    }
}
