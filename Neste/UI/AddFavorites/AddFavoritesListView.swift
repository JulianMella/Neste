//
//  AddFavoritesListView.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import SwiftUI

struct AddFavoritesListView: View {
    @State private var hoveredStopID: String?
    @State private var stopIDClicked: String?
    var geocoderStops: [GeocoderStop]
    
    var body: some View {
        ScrollView {
            ForEach(geocoderStops, id: \.self) { stop in
                Button {
                    stopIDClicked = (stopIDClicked == stop.id) ? nil : stop.id
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
                            VStack {
                                ForEach(MockData.addFavoriteResults, id: \.self) { line in
                                    HStack {
                                        Text(line.publicTransportNumber)
                                            .frame(width: 24, height: 24)
                                            .background(line.transportType.color)
                                            .cornerRadius(6)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(10)
                            .background(.blue)
                        }
                    }
                    .background(stop.id == hoveredStopID || stop.id == stopIDClicked ? .white.opacity(0.08) : .clear)
                    .pointerStyle(.link)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }
}
