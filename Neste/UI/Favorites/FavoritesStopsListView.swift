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
    
    var body: some View {
        ScrollView {
            VStack {
                FavoriteStopView()
                FavoriteStopView()
                FavoriteStopView()
                FavoriteStopView()
            }
        }
    }
}
