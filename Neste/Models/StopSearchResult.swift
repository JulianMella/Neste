//
//  StopSearchResult.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

struct StopSearchResult: Codable {
    let parentStop: GeocoderStop
    let hasChildrenIds: Bool
    var groupedStopMetadata: [TransportType : [StopMetadata]]
    var uniqueNsrStrings: [TransportType: Set<String>] = [:]
    
    struct StopMetadata: Hashable, Codable {
        let id: String
        let transportType: TransportType
        let finalDestination: String
        let publicTransportNumber: String
    }
}

typealias FavoriteStop = StopSearchResult
typealias FavoriteStopChild = StopSearchResult.StopMetadata
