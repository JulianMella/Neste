//
//  ContentView.swift
//  Neste
//
//  Created by Julian on 01/04/2026.
//
import SwiftUI

struct ContentView: View {
    @State private var favoriteStopViewModel = FavoriteStopViewModel()
    @State private var stopSearchViewModel = StopSearchViewModel()
    @State private var showStopSearch = false
    
    var body: some View {
        if showStopSearch {
            StopSearchView(showStopSearch: $showStopSearch)
                .environment(favoriteStopViewModel)
                .environment(stopSearchViewModel)
        } else {
            BrowseView(showStopSearch: $showStopSearch)
                .environment(favoriteStopViewModel)
                .environment(stopSearchViewModel)
        }
    }
}

