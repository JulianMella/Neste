//
//  FavoritesStopListView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

/**
 * Abstract: Displays live public transportation stop data fetched from its Observable viewmodel
 */

import SwiftUI

struct FavoriteStopsListView: View {
    @Environment(FavoriteStopViewModel.self) private var favoriteStopViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(favoriteStopViewModel.favoritedStops.keys), id: \.self) { parent in
                    FavoriteStopView(parent: parent, viewModel: favoriteStopViewModel)
                }
            }
        }
    }
}
