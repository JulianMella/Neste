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
    var features: [Feature]
    
    struct Feature: Decodable {
        var properties: Properties
        
        struct Properties: Decodable {
            // var geometry: Geometry
            var id: String
            var name: String
            var county: String
            var category: [String]
        }
    }
}

struct GeocoderStop: Hashable {
    var id: String
    var name: String
    var county: String

    // Category from GeocoderResponse.Feature.Properties is remapped to a set
    // That specific field provides a list of all the public transportation types that exist in a given stop
    // So it could be repetitive, saying [Bus, Bus, Tram, Tram] if many different lines travel through that stop
    // This datapoint is only utilized in AddFavoritesView, and there we only need unique values.
    var uniqueCategories: Set<String>
}

typealias StopPlaceParent = GeocoderStop
