//
//  FavoritesView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct FavoriteStopRow: View {
    let stop: FavoriteStop
    let viewModel: FavoriteStopViewModel
    // TODO: Move the formatter to FavoriteStopViewModel. This requires quite a bit of logic, so not just yet!
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stop.parentStop.name)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .contextMenu{
                    Button("Delete parent") {
                        viewModel.deleteParent(parent: stop.parentStop) //TODO: Better naming
                    }
                }
            ForEach(viewModel.getChildrenOf(stop.parentStop), id: \.self) { child in
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
                                                                        // TODO: This is not valid for all cases, such as late in night where only 1, 2 or 3 transport goes. - fix
                    if let arrivals = viewModel.arrivalData[child], arrivals.count > 3 {
                        Text(formatter.string(from: arrivals[0].aimedDepartureTime))
                            .font(.system(size: 16))
                        HStack {
                            ForEach(1..<4, id: \.self) { i in
                                Text(formatter.string(from: arrivals[i].aimedDepartureTime))
                                    .foregroundStyle(.gray)
                                    .frame(width: 45, alignment: .trailing)
                            }
                        }
                    }
                }
                .contextMenu {
                    Button("Delete child") {
                        viewModel.deleteFavorite(parent: stop.parentStop, child: child) //TODO: Better naming
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
