//
//  FavoriteStopViewModel.swift
//  Neste
//
//  Created by Julian on 06/04/2026.
//

import Observation

@Observable
final class FavoriteStopViewModel {
    var favoritedStops: [FavoriteStop] = [] // TODO: Persistent consider init for just this case, everything else is just stored in memory!
    var arrivalData: [FavoriteStopChild : [JourneyPlannerArrivalData]] = [:]
    private let journeyPlannerService = JourneyPlannerService()
    var hasData: Bool {
        !favoritedStops.isEmpty
    }
    
    private func index(of parent: GeocoderStop) -> Int? {
        favoritedStops.firstIndex(where: { $0.parentStop == parent })
    }
    
    private func keyAndIndex(of child: StopSearchResult.StopMetadata, in parentIndex: Int) -> (TransportType, Int)? {
        for (type, metadata) in favoritedStops[parentIndex].groupedStopMetadata {
            if let index = metadata.firstIndex(where: { $0 == child }) {
                return (type, index)
            }
        }
        
        return nil
    }
    
    func addFavorite(parent: GeocoderStop, hasChildrenIds: Bool, child: StopSearchResult.StopMetadata) {
        if let parentIndex = index(of: parent) {
            favoritedStops[parentIndex].groupedStopMetadata[child.transportType, default: []].append(child)
        } else {
            favoritedStops.append(FavoriteStop(parentStop: parent, hasChildrenIds: hasChildrenIds, groupedStopMetadata: [child.transportType : [child]]))
        }
    }
    
    func deleteFavorite(parent: GeocoderStop, child: StopSearchResult.StopMetadata) {
        if let parentIndex = index(of: parent) {
            if let childKeyAndIndex = keyAndIndex(of: child, in: parentIndex) {
                            // Keep compiler happy with "?", at this point it is safely confirmed that child exists.
                favoritedStops[parentIndex].groupedStopMetadata[childKeyAndIndex.0]?.remove(at: childKeyAndIndex.1)
            }
            
            if favoritedStops[parentIndex].groupedStopMetadata.values.allSatisfy({ $0.isEmpty }) {
                favoritedStops.remove(at: parentIndex)
            }
        }
    }
    
    func deleteParent(parent: GeocoderStop) {
        if let parentIndex = index(of: parent) {
            favoritedStops.remove(at: parentIndex)
        }
    }
    
    func contains(child: StopSearchResult.StopMetadata, in parent: GeocoderStop) -> Bool {
        guard let parentIndex = index(of: parent) else { return false }
        
        return keyAndIndex(of: child, in: parentIndex) != nil
    }
    
    func getChildrenOf(_ parent: GeocoderStop) -> [StopSearchResult.StopMetadata] {
        guard let parentIndex = index(of: parent) else { return [] }
        
        return favoritedStops[parentIndex].groupedStopMetadata.values.flatMap { $0 }
    }
    
    func fetchArrivalData(for stop: StopSearchResult) async {
        if !stop.hasChildrenIds {
            await fetchArrivalData(for: stop.parentStop)
        } else {
            for (_, children) in stop.groupedStopMetadata {
                
                // TODO: One of the big issues with this design is the fact that many of the children might share the same NSR:StopPlace:ID and therefore would make multiple calls for the exact same dataset. Therefore this must be redesigned such that the fetchArrivalData func receives a Set of NSR strings based upon the children NSR strings. Where should the set of NSR strings be created  . .. .. ...........   ????????????????????????
                
                for child in children {
                    await fetchArrivalData(for: child, in: stop.parentStop)
                }
            }
        }
    }
    
    
    // Called when StopSearchResult.hasChildrenIds == false
    func fetchArrivalData(for parent: GeocoderStop) async {
        do {
            /*isLoading = true TODO: Create isLoading array for each individual item that can be loaded.
             
             defer {
             isLoading = false
             }*/
            let arrivals = try await journeyPlannerService.fetchLiveArrivalData(stopPlaceID: parent.id)
            
            guard let parentIdx = index(of: parent) else {
                print("Could not find parent")
                return
            }
            
            let allChildren = favoritedStops[parentIdx].groupedStopMetadata.values.flatMap { $0 }
            
            // Iterate through arrivals then children first, because the other way around would be more computationally expensive
            for arrival in arrivals {
                guard let match = allChildren.first(where: {
                    arrival.finalDestination == $0.finalDestination &&
                    arrival.publicTransportNumber == $0.publicTransportNumber
                })
                else {
                    continue // TODO: Although highly improbable, child might not exist, which should be communicated
                }
                
                arrivalData[match, default: []].append(arrival)
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
    
    func fetchArrivalData(for child: StopSearchResult.StopMetadata, in parent: GeocoderStop) async {
        do {
            /*isLoading = true TODO: Create isLoading array for each individual item that can be loaded.
             
             defer {
             isLoading = false
             }*/
            
            let arrivals = try await journeyPlannerService.fetchLiveArrivalData(stopPlaceID: child.id)
            
            guard let parentIdx = index(of: parent) else {
                print("Could not find parent") // TODO: Handle this xd...
                return
            }
            
            let allChildren = favoritedStops[parentIdx].groupedStopMetadata.values.flatMap { $0 }
            
            // Iterate through arrivals then children first, because the other way around would be more computationally expensive
            for arrival in arrivals {
                guard let match = allChildren.first(where: {
                    arrival.finalDestination == $0.finalDestination &&
                    arrival.publicTransportNumber == $0.publicTransportNumber
                })
                else {
                    continue // TODO: Although highly improbable, child might not exist, which should be communicated
                }
                
                arrivalData[match, default: []].append(arrival)
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
