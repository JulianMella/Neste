//
//  GeocoderService.swift
//  Neste
//
//  Created by Julian on 01/04/2026.
//

import Foundation

struct GeocoderAutocomplete: Endpoint {
    var url: String
}

final class GeocoderService {
    let geocoderEndpoint = GeocoderAutocomplete(url: "https://api.entur.io/geocoder/v1/autocomplete?text=")
    
    func autocomplete(query: String) async throws -> [GeocoderStop] {
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(for: geocoderEndpoint.makeRequest(query))
        } catch {
            throw EndpointError.networkError(error)
        }
            
        try geocoderEndpoint.validateHTTPResponse(response)
         
        let decoded: GeocoderResponse
        
        do {
            decoded = try JSONDecoder().decode(GeocoderResponse.self, from: data)
        } catch {
            throw EndpointError.decodingError(error)
        }
        
        return decoded.features.map {
            GeocoderStop(
                id: $0.properties.id,
                name: $0.properties.name,
                county: $0.properties.county,
                uniqueCategories: Set($0.properties.category)
            )
        }
    }
}
