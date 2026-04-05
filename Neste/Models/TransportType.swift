//
//  TransportType.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

enum TransportType {
    case bus, tram, metro // TODO: Add boat, train, green bus
    
    init?(_ string: String, queryType: QueryType) {
        if queryType == .geocoder {
            switch string {
            case "onstreetBus": self = .bus
            case "onstreetTram": self = .tram
            case "metroStation": self = .metro
            default: return nil
            }
        }
        else if queryType == .journeyPlanner {
            switch string {
            case "bus": self = .bus
            case "tram": self = .tram
            case "metro": self = .metro
            default: return nil
            }
        } else {
            return nil
        }
    }
    
    var color: Color {
        switch self {
        case .bus: return .red
        case .tram: return .blue
        case .metro: return .orange
        }
    }
    
    var sfSymbol: String {
        switch self {
        case .bus: return "bus.fill"
        case .tram: return "tram.fill"
        case .metro: return "train.side.front.car"
        }
    }
}

enum QueryType {
    case geocoder, journeyPlanner
}
