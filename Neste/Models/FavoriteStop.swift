//
//  FavoriteStop.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

struct FavoriteStop: Hashable {
    let location: String
    var lines: [Line]
    
    struct Line: Hashable {
        let publicTransportNumber: String
        let transportType: TransportType
        let finalDestination: String
        var upcomingArrivals: [String]
    }
    
    var transportTypes: Set<TransportType> {
        var set: Set<TransportType> = []
        
        for line in lines {
            set.insert(line.transportType)
        }
        
        return set
    }
}
