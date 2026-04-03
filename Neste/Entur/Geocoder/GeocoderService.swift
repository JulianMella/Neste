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
    
    func autocomplete(query: String) async throws -> [Feature]? {
        do {
            let (data, response) = try await URLSession.shared.data(for: geocoderEndpoint.makeRequest(query))
            
            let decoded = try JSONDecoder().decode(GeocoderResponse.self, from: data)
            print(response)
            print(decoded)
        } catch {
            print("Fetch error:", error)
        }
        return nil
    }
}
