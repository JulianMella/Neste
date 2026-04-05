//
//  JourneyPlannerModels.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

import Foundation

struct GraphQLData<T: Decodable>: Decodable {
    var data: T
}

struct JourneyPlannerResponse: Decodable {
    var stopPlace: StopPlace
    
    struct StopPlace: Decodable {
        var estimatedCalls: [EstimatedCall]
        
        struct EstimatedCall: Decodable {
            var destinationDisplay: DestinationDisplay
            var serviceJourney: ServiceJourney
            
            struct DestinationDisplay: Decodable {
                var frontText: String
            }
            
            struct ServiceJourney: Decodable {
                var journeyPattern: JourneyPattern
                var transportMode: String
                
                struct JourneyPattern: Decodable {
                    var line: Line
                    
                    struct Line: Decodable {
                        var publicCode: String
                    }
                }
            }
        }
    }
}

struct JourneyPlannerData: Hashable { // TODO: Find a less generic name for this
    var publicCode: String
    var frontText: String
    var transportType: TransportType
}
