//
//  JourneyPlannerService.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

import Foundation

struct JourneyPlanner: GraphQLEndpoint {
    var baseUrl: String = "https://api.entur.io/journey-planner/v3/graphql"
}

final class JourneyPlannerService {
    let journeyPlanner = JourneyPlanner()
    
    func fetchStopData(stopPlaceID: String) async throws -> [StopPlace] {
        let query = """
            {
              stopPlace(id: "\(stopPlaceID)") {
                estimatedCalls(
                    numberOfDeparturesPerLineAndDestinationDisplay: 1
                  numberOfDepartures: 100
                  whiteListed: {authorities: ["RUT:Authority:RUT"]}
                ) {
                  destinationDisplay {
                    frontText
                  }
                  serviceJourney {
                    journeyPattern {
                      line {
                        publicCode
                      }
                    }
                  }
                }
              }
            }
            """

        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(for: journeyPlanner.makeRequest(with: query))
        } catch {
            throw EndpointError.networkError(error)
        }

        try journeyPlanner.validateHTTPResponse(response)
        
        let decoded: GraphQLData<StopPlaceData>
        
        do {
            decoded = try JSONDecoder().decode(GraphQLData<StopPlaceData>.self, from: data)
        } catch {
            throw EndpointError.decodingError(error)
        }
        
        // TODO: Handle empty list!
        return decoded.data.stopPlace.estimatedCalls.map {
            StopPlace(
                publicCode: $0.serviceJourney.journeyPattern.line.publicCode,
                frontText: $0.destinationDisplay.frontText
            )
        }
    }
}
