//
//  FavoritesView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct FavoriteStopView: View {
    let parent: GeocoderStop
    let viewModel: FavoriteStopViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(parent.name)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .contextMenu{
                    Button("Delete parent") {
                        viewModel.deleteParent(parent: parent) //TODO: Better naming
                    }
                }
            ForEach(viewModel.getChildrenOf(parent), id: \.self) { child in
                HStack {
                    Text(child.publicTransportNumber)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 28)
                        .background(child.transportType.color)
                        .cornerRadius(8)
                    Text(child.finalDestination)
                        .font(.system(size: 16))
                    Spacer(minLength: 24)
                    
                    /*Text(line.upcomingArrivals[0])
                        .font(.system(size: 16))
                    HStack {
                        ForEach(line.upcomingArrivals.dropFirst(), id: \.self) { arrival in
                            Text(arrival)
                                .foregroundStyle(.gray)
                                .frame(width: 45, alignment: .trailing)
                        }
                    }*/
                }
                .contextMenu {
                    Button("Delete child") {
                        viewModel.deleteFavorite(parent: parent, child: child) //TODO: Better naming
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
