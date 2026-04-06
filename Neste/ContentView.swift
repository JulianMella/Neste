//
//  ContentView.swift
//  Neste
//
//  Created by Julian on 01/04/2026.
//
import SwiftUI

struct ContentView: View {
    @State private var favoriteStopViewModel = FavoriteStopViewModel()
    @State private var showAddFavorites = false
    
    var body: some View {
        if showAddFavorites {
            AddFavoritesView(showAddFavorites: $showAddFavorites)
                .environment(favoriteStopViewModel)
        } else {
            BrowseView(showAddFavorites: $showAddFavorites)
                .environment(favoriteStopViewModel)
        }
    }
}

