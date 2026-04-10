//
//  StopSearchViewModel.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import Observation
import Foundation

@Observable
final class StopSearchViewModel {
    var searchResults: [StopSearchResult] = []
    var isLoading: Bool = false
    var errorMessage: String = ""
    
    private let geocoderService = GeocoderService()
    private let stopPlaceService = StopPlaceService()
    private let journeyPlannerService = JourneyPlannerService()
    
    func search(_ query: String) async {
        do {
            var queryResults: [StopSearchResult] = []

            isLoading = true
            
            defer {
                isLoading = false
            }
            
            var stops: [GeocoderStop] = try await geocoderService.autocomplete(query: query)
            
            stops = cleanUpData(of: stops)
            
            for stop in stops {
                queryResults.append(
                    StopSearchResult(
                        parentStop: stop,
                        hasChildrenIds: false,
                        groupedStopMetadata: Dictionary(uniqueKeysWithValues: stop.transportTypes.map {($0, [])})
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
    
    func loadStopMetadata(for parent: GeocoderStop, in transportType: TransportType) async {
        guard let searchResultIdx = searchResults.firstIndex(where: { $0.parentStop == parent })
        else {
            return
        }
        do {
            let children = try await stopPlaceService.fetchChildren(parentID: parent.id)
            let hasChildrenIds = !children.isEmpty
            let stopIDs = hasChildrenIds ? children.map{$0.id} : [parent.id]

            var stopMetadata = try await fetchStopMetadata(for: stopIDs)

            stopMetadata = sortMetadata(stopMetadata)
            
            searchResults[searchResultIdx].groupedStopMetadata = groupMetadata(stopMetadata)
            searchResults[searchResultIdx].hasChildrenIds = hasChildrenIds
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
    
    private func cleanUpData(of stops: [GeocoderStop]) ->  [GeocoderStop]{
        return sortTransportTypes(in: filter(stops))
    }
    
    
    private func filter(_ stops: [GeocoderStop]) -> [GeocoderStop] {
                                                                // A basic solution to allow for support of multiple regions.
                                                                // I will not give this much thought unless the app gains a relative amount of popularity
        return stops.filter{ $0.id.hasPrefix("NSR:StopPlace") && supportedRegions.authorities.keys.contains($0.county)}
    }
    
    private func sortTransportTypes(in stops: [GeocoderStop]) -> [GeocoderStop] {
        stops.map {
            return GeocoderStop(
                id: $0.id,
                name: $0.name,
                county: $0.county,
                transportTypes: $0.transportTypes.sorted(by: {$0.sortOrder < $1.sortOrder})
            )
        }
    }

    private func fetchStopMetadata(for stopIDs: [String]) async throws -> [StopSearchResult.StopMetadata] {
        var metadata: [StopSearchResult.StopMetadata] = []
        
        for id in stopIDs {
            let departures = try await journeyPlannerService.fetchStopData(stopPlaceID: id)
            
            for departure in departures {
                metadata.append(
                    StopSearchResult.StopMetadata(
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
    
    private func sortMetadata(_ metadata: [StopSearchResult.StopMetadata]) -> [StopSearchResult.StopMetadata] {
        return metadata.sorted(by: {$0.publicTransportNumber.localizedStandardCompare($1.publicTransportNumber) == .orderedAscending})
    }
    
    private func groupMetadata(_ metadata: [StopSearchResult.StopMetadata]) -> [TransportType: [StopSearchResult.StopMetadata]] {
        return Dictionary(grouping: metadata, by: \.transportType)
    }
}
