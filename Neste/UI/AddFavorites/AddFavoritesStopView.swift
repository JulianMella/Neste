//
//  AddFavoritesStopView.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

// TODO: MASSIVE REFACTORIZATION OF IT ALL, SOON TO COME.

import SwiftUI

struct AddFavoritesStopView: View {
    let addFavoritesResult: AddFavoritesResult
    @Binding var hoveredStopID: String?
    @Binding var stopIDClicked: String?
    let proxy: ScrollViewProxy
    
    var parentId: String {
        addFavoritesResult.parentStop.id
    }
    
    var parentName: String {
        addFavoritesResult.parentStop.name
    }
    
    var transportTypes: [TransportType] {
        addFavoritesResult.parentStop.transportTypes
    }

    private var bottomRadius: CGFloat {
        parentId == stopIDClicked ? 0 : 12
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                stopIDClicked = (stopIDClicked == parentId) ? nil : parentId
                withAnimation {
                    proxy.scrollTo(parentId)
                }
            } label: {
                VStack {
                    HStack(spacing: 8) {
                        Text(parentName)
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
                        hoveredStopID = isHovered ? parentId : nil
                    }
                }
                .id(parentId)
                .background(parentId == hoveredStopID || parentId == stopIDClicked ? .white.opacity(0.08) : .clear)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: bottomRadius, bottomTrailingRadius: bottomRadius, topTrailingRadius: 12))
            }
            .buttonStyle(.plain)

            if parentId == stopIDClicked {
                ExpandedStopView(transportTypes: transportTypes, groupedStopMetadata: addFavoritesResult.groupedStopMetadata, parent: addFavoritesResult.parentStop, hasChildrenIds: addFavoritesResult.hasChildrenIds)
                    .background(.white.opacity(0.08))
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0))
            }
        }
    }
}

/* MASSIVE TODO: There is some lag when opening a certain row, this is because a lot of computation happens at that point. Consider moving as much as possible up to AddFavoritesStopView */

struct ExpandedStopView: View {
    let transportTypes: [TransportType]
    let groupedStopMetadata: [TransportType: [AddFavoritesResult.StopMetadata]]
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
                    Task {
                        await favoriteStopViewModel.addFavorite(parent: parent, hasChildrenIds: hasChildrenIds, child: stop)
                    }
                }
            } label: {
                Image(systemName: isFavorited ? "star.fill" : "star")
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
    }
}
