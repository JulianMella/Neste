//
//  AddFavoritesStopView.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

// TODO: MASSIVE REFACTORIZATION OF IT ALL, SOON TO COME.

import SwiftUI

struct AddFavoritesStopView: View {
    let parentStopMetadata: GeocoderStop
    let hasChildrenIds: Bool
    let expandedStopMetadata: [AddFavoritesResult.StopMetadata]
    @Binding var hoveredStopID: String?
    @Binding var stopIDClicked: String?
    let proxy: ScrollViewProxy

    var transportTypes: [TransportType] {
        parentStopMetadata.uniqueCategories.map{
            TransportType($0, queryType: .geocoder)!
        }
    }

    private var bottomRadius: CGFloat {
        parentStopMetadata.id == stopIDClicked ? 0 : 12
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                stopIDClicked = (stopIDClicked == parentStopMetadata.id) ? nil : parentStopMetadata.id
                withAnimation {
                    proxy.scrollTo(parentStopMetadata.id)
                }
            } label: {
                VStack {
                    HStack(spacing: 8) {
                        Text(parentStopMetadata.name)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Spacer()
                        ForEach(transportTypes, id: \.self) { transportType in
                            Image(systemName: transportType.sfSymbol)
                                .frame(width: 24, height: 24)
                                .background(transportType.color)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                    .onHover { isHovered in
                        hoveredStopID = isHovered ? parentStopMetadata.id : nil
                    }
                }
                .id(parentStopMetadata.id)
                .background(parentStopMetadata.id == hoveredStopID || parentStopMetadata.id == stopIDClicked ? .white.opacity(0.08) : .clear)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: bottomRadius, bottomTrailingRadius: bottomRadius, topTrailingRadius: 12))
            }
            .buttonStyle(.plain)

            if parentStopMetadata.id == stopIDClicked {
                ExpandedStopView(transportTypes: transportTypes, expandedStopMetadata: expandedStopMetadata, parent: parentStopMetadata, hasChildrenIds: hasChildrenIds)
                    .background(.white.opacity(0.08))
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0))
            }
        }
    }
}

/* MASSIVE TODO: There is some lag when opening a certain row, this is because a lot of computation happens at that point. Consider moving as much as possible up to AddFavoritesStopView */

struct ExpandedStopView: View {
    let transportTypes: [TransportType]
    let expandedStopMetadata: [AddFavoritesResult.StopMetadata]
    let parent: GeocoderStop
    let hasChildrenIds: Bool
    @State private var selectedTab = 0
    
    var pickerItems: [(String, String?)] {
        transportTypes.map{($0.pickerText, nil)}
    }

    // This must be a computed property to guarantee that expandedStopMetadata exists
    var sortedMetadata: [AddFavoritesResult.StopMetadata] {
        sortMetadata(expandedStopMetadata)
    }

    var groupedMetadata: [TransportType : [AddFavoritesResult.StopMetadata]] {
        groupMetadata(sortedMetadata)
    }

    var body: some View {
        Divider()
        VStack(spacing: 16) {
            if transportTypes.count > 1 {
                SegmentedPicker(selection: $selectedTab, items: pickerItems)
                .frame(maxWidth: 200)
            }
            if let stopGroup = groupedMetadata[transportTypes[selectedTab]] {
                ForEach(stopGroup, id: \.self) { stop in
                    StopMetadataRow(stop: stop, hasChildrenIds: hasChildrenIds, parent: parent)
                }
            } else {
                Text("No transportation found at this stop")
                    .frame(maxWidth: .infinity)
            }
            
        }
        .padding(10)
    }
}

struct StopMetadataRow: View {
    @Environment(FavoriteStopViewModel.self) private var favoriteStopViewModel
    let stop: AddFavoritesResult.StopMetadata
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
