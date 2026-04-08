//
//  AddFavoritesResult.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

struct AddFavoritesResult {
    let parentStop: GeocoderStop
    let hasChildrenIds: Bool
    var groupedStopMetadata: [TransportType : [StopMetadata]]
    
    struct StopMetadata: Hashable {
        let id: String
        let transportType: TransportType
        let finalDestination: String
        let publicTransportNumber: String
    }
}

typealias FavoriteStop = AddFavoritesResult
typealias FavoriteStopChild = AddFavoritesResult.StopMetadata
