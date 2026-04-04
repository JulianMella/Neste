//
//  AddFavoritesViewModel.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import Observation

@Observable class AddFavoritesViewModel {
    var errorMessage: String
    var geocoderResults: [GeocoderStop]
    var isLoading: Bool
    
    private let geocoderService: GeocoderService
    
    init() {
        self.errorMessage = ""
        self.geocoderResults = []
        self.isLoading = false
        self.geocoderService = GeocoderService()
    }
    
    func search(_ query: String) async {
        do {
            isLoading = true
            
            defer {
                isLoading = false
            }
            
            let stops: [GeocoderStop] = try await geocoderService.autocomplete(query: query)
            
            print(stops)
            
            geocoderResults = filter(stops)
            
            print(geocoderResults)
            
            
        } catch EndpointError.networkError(let URLError) {
            // TODO: Handle this
        } catch EndpointError.httpError(let statusCode) {
            // TODO: Handle this
        } catch EndpointError.decodingError {
            // TODO: Handle this
        } catch {
            // TODO: Handle this
        }
    }
    
    private func filter(_ stops: [GeocoderStop]) -> [GeocoderStop] {
        return stops.filter { $0.county == "Oslo" && $0.id.hasPrefix("NSR:StopPlace")}
    }
}
