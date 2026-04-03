//
//  FavoriteStop.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import Foundation

struct FavoriteStop {
    let location: String
    var lines: [Line]
    
    struct Line {
        let publicTransportNumber: String
        let transportType: TransportType
        let finalDestination: String
        var upcomingArrivals: [Date]
    }
    
    var transportTypes: Set<TransportType> {
        var set: Set<TransportType> = []
        
        for line in lines {
            set.insert(line.transportType)
        }
        
        return set
    }
}
