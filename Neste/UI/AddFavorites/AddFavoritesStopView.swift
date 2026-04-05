//
//  AddFavoritesStopView.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

import SwiftUI

struct AddFavoritesStopView: View {
    let stop: GeocoderStop
    @Binding var hoveredStopID: String?
    @Binding var stopIDClicked: String?
    let proxy: ScrollViewProxy
    
    var body: some View {
        Button {
            stopIDClicked = (stopIDClicked == stop.id) ? nil : stop.id
            withAnimation {
                proxy.scrollTo(stop.id)
            }
        } label: {
            VStack {
                HStack(spacing: 8) {
                    Text(stop.name)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Spacer()
                    ForEach(stop.uniqueCategories.sorted(), id: \.self) { category in
                        if let tType = TransportType(category) {
                            Image(systemName: tType.sfSymbol)
                                .frame(width: 24, height: 24)
                                .background(tType.color)
                                .cornerRadius(6)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 5)
                .contentShape(RoundedRectangle(cornerRadius: 12))
                .onHover { isHovered in
                    hoveredStopID = isHovered ? stop.id : nil
                }
                
                if stop.id == stopIDClicked {
                    ExpandedStopView()
                }
            }
            .id(stop.id)
            .background(stop.id == hoveredStopID || stop.id == stopIDClicked ? .white.opacity(0.08) : .clear)
            .pointerStyle(.link)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

struct ExpandedStopView: View {
    // TODO: Pass JourneyService data down to here
    
    var body: some View {
        Divider()
        VStack(spacing: 16) {
            ForEach(MockData.addFavoriteResults, id: \.self) { line in
                HStack {
                    Text(line.publicTransportNumber)
                        .frame(width: 24, height: 24)
                        .background(line.transportType.color)
                        .cornerRadius(6)
                    Text(line.finalDestination)
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
        .padding(10)
        .contentShape(Rectangle())
        .pointerStyle(.default)
        .simultaneousGesture(DragGesture(minimumDistance: 0).onEnded { _ in })
    }
}
