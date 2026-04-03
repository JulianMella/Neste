//
//  AddFavoritesView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct AddFavoritesView: View {
    @FocusState var isSearchFocused: Bool
    @Binding var showAddFavorites: Bool
    
    var body: some View {
        VStack {
            AddFavoritesSearchBar(showAddFavorites: $showAddFavorites, isSearchFocused: $isSearchFocused)
            PulsingDots()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isSearchFocused = false
        }
    }
}
