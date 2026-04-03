//
//  AddFavoritesViewModel.swift
//  Neste
//
//  Created by Julian on 04/04/2026.
//

import Observation

@Observable class AddFavoritesViewModel {
    
    var isLoading: Bool = false
    private let geocoderService: GeocoderService
    
    init() {
        self.geocoderService = GeocoderService()
    }
    
    
    
}
