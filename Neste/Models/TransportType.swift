//
//  TransportType.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

enum TransportType {
    case bus, tram, metro // TODO: Add boat, train, green bus
    
    var color: Color {
        switch self {
        case .bus: return .red
        case .tram: return .blue
        case .metro: return .orange
        }
    }
}
