//
//  AddFavoritesViewModel.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import Observation

@Observable class AddFavoritesViewModel {
    var errorMessage: String
    var searchResults: [AddFavoritesResult]
    var isLoading: Bool
    
    private let geocoderService: GeocoderService
    private let stopPlaceService: StopPlaceService
    private let journeyPlannerService: JourneyPlannerService
    
    init() {
        self.errorMessage = ""
        self.searchResults = []
        self.isLoading = false
        self.geocoderService = GeocoderService()
        self.stopPlaceService = StopPlaceService()
        self.journeyPlannerService = JourneyPlannerService()
    }
    
    func search(_ query: String) async {
        do {
            var queryResults: [AddFavoritesResult] = []

            isLoading = true
            
            defer {
                isLoading = false
            }
            
            var stops: [GeocoderStop] = try await geocoderService.autocomplete(query: query)

            stops = osloFilter(stops)

            for stop in stops {
                let children = try await stopPlaceService.fetchChildren(parentID: stop.id)
                let hasChildren = !children.isEmpty
                let stopIDs = hasChildren ? children.map{$0.id} : [stop.id]

                let stopMetadata = try await fetchStopMetadata(for: stopIDs)

                queryResults.append(
                    AddFavoritesResult(
                        parentStop: stop,
                        hasChildren: hasChildren,
                        stopMetadata: stopMetadata
                    )
                )
            }

            searchResults = queryResults

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
    
    private func osloFilter(_ stops: [GeocoderStop]) -> [GeocoderStop] {
        return stops.filter { $0.county == "Oslo" && $0.id.hasPrefix("NSR:StopPlace")}
    }

    private func fetchStopMetadata(for stopIDs: [String]) async throws -> [AddFavoritesResult.StopMetadata] {
        var metadata: [AddFavoritesResult.StopMetadata] = []
        print("in")
        for id in stopIDs {
            let departures = try await journeyPlannerService.fetchStopData(stopPlaceID: id)
            print("problem")
            for departure in departures {
                metadata.append(
                    AddFavoritesResult.StopMetadata(
                        id: id,
                        transportType: departure.transportType,
                        finalDestination: departure.frontText,
                        publicTransportNumber: departure.publicCode
                    )
                )
            }
        }

        return metadata
    }
}
