//
//  FavoriteStopViewModel.swift
//  Neste
//
//  Created by Julian on 06/04/2026.
//

import Observation

@Observable
final class FavoriteStopViewModel {
    var favoritedStops: [FavoriteStop] = [] // TODO: Persistent!
    var arrivalData: [String : [JourneyPlannerArrivalData]] = [:]
    private let journeyPlannerService = JourneyPlannerService()
    
    private func index(of parent: GeocoderStop) -> Int? {
        favoritedStops.firstIndex(where: { $0.parentStop == parent })
    }
    
    private func index(of child: AddFavoritesResult.StopMetadata, in parentIndex: Int) -> Int? {
        favoritedStops[parentIndex].stopMetadata.firstIndex(where: { $0 == child })
    }
    
    func addFavorite(parent: GeocoderStop, hasChildrenIds: Bool, child: AddFavoritesResult.StopMetadata) {
        if let parentIndex = index(of: parent) {
            favoritedStops[parentIndex].stopMetadata.append(child)
        } else {
            favoritedStops.append(FavoriteStop(parentStop: parent, hasChildrenIds: hasChildrenIds, stopMetadata: [child]))
        }
    }
    
    func deleteFavorite(parent: GeocoderStop, child: AddFavoritesResult.StopMetadata) {
        if let parentIndex = index(of: parent) {
            if let childIndex = index(of: child, in: parentIndex) {
                favoritedStops[parentIndex].stopMetadata.remove(at: childIndex)
            }
            
            if favoritedStops[parentIndex].stopMetadata.isEmpty {
                favoritedStops.remove(at: parentIndex)
            }
        }
    }
    
    func deleteParent(parent: GeocoderStop) {
        if let parentIndex = index(of: parent) {
            favoritedStops.remove(at: parentIndex)
        }
    }
    
    func contains(child: AddFavoritesResult.StopMetadata, in parent: GeocoderStop) -> Bool {
        guard let parentIndex = index(of: parent) else { return false }
        
        return favoritedStops[parentIndex].stopMetadata.contains{ $0 == child }
    }
    
    func getChildrenOf(_ parent: GeocoderStop) -> [AddFavoritesResult.StopMetadata] {
        guard let parentIndex = index(of: parent) else { return [] }
        
        return favoritedStops[parentIndex].stopMetadata
    }
    
    // Called when AddFavoritesResult.hasChildrenIds == false
    func fetchArrivalData(for parent: GeocoderStop) async {
        do {
            /*isLoading = true TODO: Create isLoading array for each individual item that can be loaded.
             
             defer {
             isLoading = false
             }*/
            let arrivals = try await journeyPlannerService.fetchLiveArrivalData(stopPlaceID: parent.id)
            
            for arrival in arrivals {
                print(arrival)
            }
            
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
    
    func fetchArrivalData(for child: AddFavoritesResult.StopMetadata) async {
        do {
            /*isLoading = true TODO: Create isLoading array for each individual item that can be loaded.
             
             defer {
             isLoading = false
             }*/
            
            let arrivals = try await journeyPlannerService.fetchLiveArrivalData(stopPlaceID: child.id)
            
            for arrival in arrivals {
                print(arrival)
            }
            
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
    
    func fetchArrivalData(for children: [AddFavoritesResult.StopMetadata]) async {
        do {
            /*isLoading = true TODO: Create isLoading array for each individual item that can be loaded.
             
             defer {
             isLoading = false
             }*/
            for child in children {
                let arrivals = try await journeyPlannerService.fetchLiveArrivalData(stopPlaceID: child.id)
                
                for arrival in arrivals {
                    print(arrival)
                }
            }
            
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
    
    
     // UpdateArrivalData, when the amount of arrival data goes down to four for a certain nsr stop place, call fetchArrivalData from the point in time of the last arrival data that we have and get 4 queries!
}
