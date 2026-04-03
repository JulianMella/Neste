//
//  FavoriteStop.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import Foundation

struct FavoriteStop {
    let publicTransportNumber: String
    let transportType: TransportType
    let finalDestation: String
    let stop: String
    var upcomingArrivals: [Date]
}
