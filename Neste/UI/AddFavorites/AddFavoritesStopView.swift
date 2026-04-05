//
//  AddFavoritesStopView.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

import SwiftUI

struct AddFavoritesStopView: View {
    let parentStopMetadata: GeocoderStop
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
                ExpandedStopView(transportTypes: transportTypes, expandedStopMetadata: expandedStopMetadata)
                    .background(.white.opacity(0.08))
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0))
            }
        }
    }
}

struct ExpandedStopView: View {
    let transportTypes: [TransportType]
    let expandedStopMetadata: [AddFavoritesResult.StopMetadata]
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

            ForEach(groupedMetadata[transportTypes[selectedTab]]!, id: \.self) { stop in
                StopMetadataRow(stop: stop)
            }
        }
        .padding(10)
    }
}

struct StopMetadataRow: View {
    let stop: AddFavoritesResult.StopMetadata
    @State private var isFavorited = false // TODO: Replace this with an actual check if it has been favorited from before!
    
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
                // TODO: Propagate favorites marked up from here.
                isFavorited.toggle()
            } label: {
                Image(systemName: isFavorited ? "star.fill" : "star")
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
    }
}
