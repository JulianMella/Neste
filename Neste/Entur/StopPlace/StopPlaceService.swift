//
//  StopPlaceService.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

import Foundation

struct StopPlaceEndpoint: RESTEndpoint {
    var baseUrl: String
}

final class StopPlaceService {
    let stopPlaceEndpoint = StopPlaceEndpoint(baseUrl: "https://api.entur.io/stop-places/v1/read/stop-places/") // TODO: Convert this to URLComponents
    
    func fetchChildren(parentID: String) async throws -> [StopPlaceResponse] {
        
        let query = parentID + "/children"
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(for: stopPlaceEndpoint.makeRequest(with: query))
        } catch {
            throw EndpointError.networkError(error)
        }

        try stopPlaceEndpoint.validateHTTPResponse(response)

        let decoded: [StopPlaceResponse]

        do {
            decoded = try JSONDecoder().decode([StopPlaceResponse].self, from: data)
        } catch {
            throw EndpointError.decodingError(error)
        }
        
        return decoded
    }
}
