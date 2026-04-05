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
    
    var body: some View {
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
                    ForEach(parentStopMetadata.uniqueCategories.sorted(), id: \.self) { category in
                        if let tType = TransportType(category, queryType: .geocoder) {
                            Image(systemName: tType.sfSymbol)
                                .frame(width: 24, height: 24)
                                .background(tType.color)
                                .cornerRadius(6)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, parentStopMetadata.id == stopIDClicked ? 5 : 10)
                .contentShape(RoundedRectangle(cornerRadius: 12))
                .onHover { isHovered in
                    hoveredStopID = isHovered ? parentStopMetadata.id : nil
                }
                
                if parentStopMetadata.id == stopIDClicked {
                    ExpandedStopView(expandedStopMetadata: expandedStopMetadata)
                }
            }
            .id(parentStopMetadata.id)
            .background(parentStopMetadata.id == hoveredStopID || parentStopMetadata.id == stopIDClicked ? .white.opacity(0.08) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

struct ExpandedStopView: View {
    let expandedStopMetadata: [AddFavoritesResult.StopMetadata]
    
    var body: some View {
        Divider()
        VStack(spacing: 16) {
            ForEach(expandedStopMetadata, id: \.self) { stop in
                HStack {
                    Text(stop.publicTransportNumber)
                        .frame(width: 24, height: 24)
                        .background(stop.transportType.color)
                        .cornerRadius(6)
                    Text(stop.finalDestination)
                        .font(.system(size: 16))
                    Spacer()
                    Button {
                        // TODO: Propagate favorites marked up from here.
                    } label: {
                        Image(systemName: "star")
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 10)
        .padding(.horizontal, 10)
        .contentShape(Rectangle())
        .pointerStyle(.default)
        .simultaneousGesture(DragGesture(minimumDistance: 0).onEnded { _ in })
    }
}
