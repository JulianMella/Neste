//
//  AddFavoritesResult.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

struct AddFavoritesResult: Hashable {
    let parentStop: GeocoderStop
    let hasChildren: Bool
    let stopMetadata: [StopMetadata]
    
    struct StopMetadata: Hashable {
        let id: String
        let transportType: TransportType
        let finalDestination: String
        let publicTransportNumber: String
    }
}
