//
//  AddFavoritesListView.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import SwiftUI

struct AddFavoritesListView: View {
    var searchResults: [AddFavoritesResult]
    @State private var hoveredStopID: String?
    @State private var stopIDClicked: String?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(searchResults, id: \.self) { result in
                    AddFavoritesStopView(
                        parentStopMetadata: result.parentStop,
                        expandedStopMetadata: result.stopMetadata,
                        hoveredStopID: $hoveredStopID,
                        stopIDClicked: $stopIDClicked,
                        proxy: proxy
                    )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scrollIndicators(.never)
        }
    }
}
