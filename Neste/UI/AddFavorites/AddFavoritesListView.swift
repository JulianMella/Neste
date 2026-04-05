//
//  AddFavoritesListView.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import SwiftUI

struct AddFavoritesListView: View {
    var geocoderStops: [GeocoderStop]
    @State private var hoveredStopID: String?
    @State private var stopIDClicked: String?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(geocoderStops, id: \.self) { stop in
                    AddFavoritesStopView(
                        stop: stop,
                        hoveredStopID: $hoveredStopID,
                        stopIDClicked: $stopIDClicked,
                        proxy: proxy)
                }
            }
        }
    }
}
