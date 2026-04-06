//
//  FavoriteStopViewModel.swift
//  Neste
//
//  Created by Julian on 06/04/2026.
//

import Observation

@Observable
final class FavoriteStopViewModel {
    var favoritedStops: [GeocoderStop : [AddFavoritesResult.StopMetadata]] = [:] // TODO: Persistent!
    
    
    func addFavorite(parent: GeocoderStop, child: AddFavoritesResult.StopMetadata) {
        favoritedStops[parent, default: []].append(child)
    }
    
    func delFavorite(parent: GeocoderStop, child: AddFavoritesResult.StopMetadata) {
        favoritedStops[parent]?.removeAll { $0 == child }
            
        if favoritedStops[parent]?.isEmpty == true {
            favoritedStops.removeValue(forKey: parent)
        }
    }
    
    func contains(parent: GeocoderStop, child: AddFavoritesResult.StopMetadata) -> Bool {
        return favoritedStops[parent]?.contains(child) ?? false
    }
}
