//
//  FavoritesView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct FavoriteStopView: View {
    let stop: FavoriteStop
    
    init(_ stop: FavoriteStop) {
        self.stop = stop;
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stop.location)
                .font(.system(size: 18))
                .fontWeight(.semibold)
            ForEach(stop.lines, id: \.self) { line in
                HStack {
                    Text(line.publicTransportNumber)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 28)
                        .background(line.transportType.color)
                        .cornerRadius(8)
                    Text(line.finalDestination)
                        .font(.system(size: 16))
                    Spacer(minLength: 24)
                    
                    Text(line.upcomingArrivals[0])
                        .font(.system(size: 16))
                    HStack {
                        ForEach(line.upcomingArrivals.dropFirst(), id: \.self) { arrival in
                            Text(arrival)
                                .foregroundStyle(.gray)
                                .frame(width: 45, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
