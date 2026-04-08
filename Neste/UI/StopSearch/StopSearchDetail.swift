//
//  StopSearchDetail.swift
//  Neste
//
//  Created by Julian on 08/04/2026.
//

import SwiftUI

struct StopSearchDetail: View {
    let transportTypes: [TransportType]
    let groupedStopMetadata: [TransportType: [StopSearchResult.StopMetadata]]
    let parent: GeocoderStop
    let hasChildrenIds: Bool
    @State private var selectedTab = 0
    
    var pickerItems: [(String, String?)] {
        transportTypes.map{($0.pickerText, nil)}
    }

    var body: some View {
        Divider()
        VStack(spacing: 16) {
            if transportTypes.count > 1 {
                SegmentedPicker(selection: $selectedTab, items: pickerItems)
                .frame(maxWidth: 200)
            }
            if let stopGroup = groupedStopMetadata[transportTypes[selectedTab]] {
                ForEach(stopGroup, id: \.self) { stop in
                    StopSearchLineRow(stop: stop, hasChildrenIds: hasChildrenIds, parent: parent)
                }
            } else {
                Text("No transportation found at this stop")
                    .frame(maxWidth: .infinity)
            }
            
        }
        .padding(10)
    }
}

struct StopSearchLineRow: View {
    @Environment(FavoriteStopViewModel.self) private var favoriteStopViewModel
    let stop: StopSearchResult.StopMetadata
    let hasChildrenIds: Bool
    let parent: GeocoderStop
    var isFavorited: Bool { favoriteStopViewModel.contains(child: stop, in: parent) }
    
    var body: some View {
        HStack {
            Text(stop.publicTransportNumber)
                .frame(width: 24, height: 24)
                // .padding(.horizontal, stop.publicTransportNumber.count > 1 ? 6 : 8) // TODO: Not satisfied with this result.
                .background(stop.transportType.color)
                .cornerRadius(6)
            Text(stop.finalDestination)
                .font(.system(size: 16))
            Spacer()
            Button {
                if isFavorited {
                    favoriteStopViewModel.deleteFavorite(parent: parent, child: stop)
                } else {
                    favoriteStopViewModel.addFavorite(parent: parent, hasChildrenIds: hasChildrenIds, child: stop)
                }
            } label: {
                Image(systemName: isFavorited ? "star.fill" : "star")
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
    }
}
