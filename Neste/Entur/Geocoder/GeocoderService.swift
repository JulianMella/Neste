//
//  GeocoderService.swift
//  Neste
//
//  Created by Julian on 01/04/2026.
//

import Foundation

struct GeocoderAutocomplete: RESTEndpoint {
    var baseUrl: String
}

struct GeocoderService {
    let geocoderEndpoint = GeocoderAutocomplete(baseUrl: "https://api.entur.io/geocoder/v1/autocomplete?text=") // TODO: Convert this to URLComponents
    
    func autocomplete(query: String) async throws -> [GeocoderStop] {
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(for: geocoderEndpoint.makeRequest(with: query))
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
        
        return decoded.features.compactMap { call -> GeocoderStop? in
            let transportTypeSet: Set<TransportType> = Set(call.properties.category.compactMap {
                TransportType($0, queryType: .geocoder)
            })
            
            guard !transportTypeSet.isEmpty else { return nil }
            
            return GeocoderStop(
                id: call.properties.id,
                name: call.properties.name,
                county: call.properties.county,
                transportTypes: Array(transportTypeSet) // The set is converted back to an array such that we can apply ordering logic to it.
            )
        }
    }
}
