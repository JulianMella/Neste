//
//  GeocoderModels.swift
//  Neste
//
//  Created by Julian on 31/03/2026.
//

import Foundation

struct GeocoderResponse: Decodable {
    var features: [Feature]
}

struct Feature: Decodable {
    var properties: Properties
    
}
struct Properties: Decodable {
    // var geometry: Geometry
    var id: String
    var name: String
    var county: String
    var category: [String]
}

// A lot of the data from the JSON response is omitted as we do not care about it.
// The Geometry key-value pair in Properties will be relevant if map functionality is implemented in the future
