//
//  FavoritesView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

/**
 * Abstract: Displays live public transportation stop data fetched from its Observable viewmodel
 */

import SwiftUI

struct FavoriteStopsListView: View {
    var mockData = FavoriteStopsModel.mockData
    
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(mockData, id: \.self) { stop in
                    FavoriteStopView(stop)
                }
            }
        }
    }
}
