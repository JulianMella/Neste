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
    @State private var hoveredStopID: String?
    @State private var stopIDClicked: String?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ForEach(favoriteStopViewModel.favoritedStops, id: \.parentStop.id) { stop in
                        StopRow(
                            stopSearchResult: stop,
                            stopRowType: .favoriteStop,
                            hoveredStopID: $hoveredStopID,
                            stopIDClicked: $stopIDClicked,
                            proxy: proxy,
                        )
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scrollIndicators(.never)
        }
    }
}
