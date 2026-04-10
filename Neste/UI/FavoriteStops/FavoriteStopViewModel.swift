//
//  FavoriteStopViewModel.swift
//  Neste
//
//  Created by Julian on 06/04/2026.
//

import Foundation
import Observation

@Observable
final class FavoriteStopViewModel {
    var favoritedStops: [FavoriteStop] = [] {
        didSet { save() }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "favoritedStops"),
           let decoded = try? JSONDecoder().decode([FavoriteStop].self, from: data) {
                favoritedStops = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(favoritedStops) {
            UserDefaults.standard.set(data, forKey: "favoritedStops")
        }
    }
    
    var arrivalData: [FavoriteStopChild : [JourneyPlannerArrivalData]] = [:]
    
    private let journeyPlannerService = JourneyPlannerService()
    
    var hasData: Bool {
        !favoritedStops.isEmpty
    }
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    func addFavorite(parent: GeocoderStop, hasChildrenIds: Bool, child: StopSearchResult.StopMetadata) {
        if let parentIndex = index(of: parent) {
            favoritedStops[parentIndex].groupedStopMetadata[child.transportType, default: []].append(child)
            
            if hasChildrenIds {
                favoritedStops[parentIndex].uniqueNsrStrings[child.transportType, default: []].insert(child.id)
            }
            
        } else {
            var newFavoriteStop = FavoriteStop(parentStop: parent, hasChildrenIds: hasChildrenIds, groupedStopMetadata: [child.transportType : [child]])
            
            if hasChildrenIds {
                newFavoriteStop.uniqueNsrStrings[child.transportType, default: []].insert(child.id)
            }
            
            favoritedStops.append(newFavoriteStop)
        }
    }
    
    func deleteFavorite(parent: GeocoderStop, child: StopSearchResult.StopMetadata) {
        if let parentIndex = index(of: parent) {
            if let keyIndexUniqueNSR = keyIndexAndIsUniqueNsr(of: child, in: parentIndex) {
                                                                // Keep compiler happy with "?", at this point it is safely confirmed that child exists.
                favoritedStops[parentIndex].groupedStopMetadata[keyIndexUniqueNSR.keyIndex.key]?.remove(at: keyIndexUniqueNSR.keyIndex.index)
                
                if favoritedStops[parentIndex].groupedStopMetadata.values.allSatisfy({ $0.isEmpty }) {
                    favoritedStops.remove(at: parentIndex)
                } else if keyIndexUniqueNSR.isUniqueNsr {
                    favoritedStops[parentIndex].uniqueNsrStrings[keyIndexUniqueNSR.keyIndex.key]?.remove(child.id)
                }
            }
        }
    }
    
    func deleteParent(_ parent: GeocoderStop) {
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
    
    func loadArrivals(for stop: StopSearchResult, in transportType: TransportType) async {
        if !stop.hasChildrenIds {
            await fetchArrivalData(for: stop.parentStop)
        } else {
            await fetchArrivalData(for: stop, in: transportType)
        }
    }
    
    func hasData(for child: StopSearchResult.StopMetadata) -> Bool {
        guard let value = arrivalData[child] else { return false }
        
        return !value.isEmpty
    }
    
    func cleanUpData(for stopGroup: [StopSearchResult.StopMetadata]) {
        for stop in stopGroup {
            arrivalData[stop] = arrivalData[stop]?.filter { $0.aimedDepartureTime.timeIntervalSinceNow > 0 }
        }
        
        // Refetch if needed here.......
        
        formatDepartures(for: stopGroup)
    }
    
    func formatDepartures(for stopGroup: [StopSearchResult.StopMetadata]) {
        for stop in stopGroup {
            guard arrivalData[stop] != nil else { continue }
                
            for i in 0..<arrivalData[stop]!.count {
                arrivalData[stop]![i].aimedDepartureTimeString = formatDeparture(for: arrivalData[stop]![i].aimedDepartureTime)
            }
        }
    }
    
    private func formatDeparture(for departure: Date) -> String {
        let minutes = departure.timeIntervalSinceNow / 60
        
        if minutes <= 1.5 {
            return "Now"
        } else if minutes <= 15 {
            return "\(Int(minutes)) min"
        } else {
            return formatter.string(from: departure)
        }
    }
    
    // Called when StopSearchResult.hasChildrenIds == false
    // In this case we do not care about transport type since everything shares the same data fetch query:)
    private func fetchArrivalData(for parent: GeocoderStop) async {
        do {
            /*isLoading = true TODO: Create isLoading array for each individual item that can be loaded.
             
             defer {
             isLoading = false
             }*/
            let arrivals = try await journeyPlannerService.fetchLiveArrivalData(stopPlaceID: parent.id)
            print("HERE)?")
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
    
    private func fetchArrivalData(for stop: StopSearchResult, in transportType: TransportType) async {
        do {
            /*isLoading = true TODO: Create isLoading array for each individual item that can be loaded.
             
             defer {
             isLoading = false
             }*/
            
            print("HERE")
            
            guard let nsrStrings = stop.uniqueNsrStrings[transportType],
                  let children = stop.groupedStopMetadata[transportType]
            else {
                return
            }
            
            for nsrString in nsrStrings {
                let arrivals = try await journeyPlannerService.fetchLiveArrivalData(stopPlaceID: nsrString)
                
                for arrival in arrivals {
                    guard let match = children.first(where: {
                        arrival.finalDestination == $0.finalDestination &&
                        arrival.publicTransportNumber == $0.publicTransportNumber
                    }) else {
                        continue
                    }
                    
                    arrivalData[match, default: []].append(arrival)
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
    
    private func index(of parent: GeocoderStop) -> Int? {
        favoritedStops.firstIndex(where: { $0.parentStop == parent })
    }
    
    private func keyAndIndex(of child: StopSearchResult.StopMetadata, in parentIndex: Int) -> KeyIndex? {
        for (type, metadata) in favoritedStops[parentIndex].groupedStopMetadata {
            if let index = metadata.firstIndex(where: { $0 == child }) {
                return KeyIndex(key: type, index: index)
            }
        }
        
        return nil
    }
    
    // Bit of a verbose function name. Essentially, this function finds the key and index for a specific child and confirms
    // whether or not it is the only child holding that key.
    private func keyIndexAndIsUniqueNsr(of child: StopSearchResult.StopMetadata, in parentIndex: Int) -> KeyIndexUniqueNSR? {
        var tType: TransportType? = nil
        var childIndex: Int? = nil
        var isUniqueNsr: Bool = true
        
        for (type, metadata) in favoritedStops[parentIndex].groupedStopMetadata {
            for i in 0..<metadata.count {
                if metadata[i] == child {
                    tType = type
                    childIndex = i
                }
                
                if metadata[i] != child && metadata[i].id == child.id {
                    isUniqueNsr = false
                }
            }
        }
        
        guard let tType = tType, let childIndex = childIndex else { return nil }
        
        return KeyIndexUniqueNSR(keyIndex: KeyIndex(key: tType, index: childIndex), isUniqueNsr: isUniqueNsr)
    }
}

struct KeyIndex {
    var key: TransportType
    var index: Int
}

struct KeyIndexUniqueNSR {
    var keyIndex: KeyIndex
    var isUniqueNsr: Bool
}
