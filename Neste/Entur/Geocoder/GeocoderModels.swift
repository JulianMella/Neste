//
//  GeocoderModels.swift
//  Neste
//
//  Created by Julian on 31/03/2026.
//

// A lot of the data from the JSON response is omitted as we do not care about it.
// The Geometry key-value pair in Properties will be relevant if map functionality is implemented in the future


import Foundation

struct GeocoderResponse: Decodable {
    var features: [GeocoderFeature]
}

struct GeocoderFeature: Decodable {
    var properties: GeocoderProperties
}

struct GeocoderProperties: Decodable {
    // var geometry: Geometry
    var id: String
    var name: String
    var county: String
    var category: [String]
}

struct GeocoderStop: Hashable {
    var id: String
    var name: String
    var county: String
    var transportTypes: [TransportType]
}

typealias StopPlaceParent = GeocoderStop
