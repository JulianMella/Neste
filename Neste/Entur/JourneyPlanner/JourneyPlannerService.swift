//
//  JourneyPlannerService.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

import Foundation

struct JourneyPlannerEndpoint: GraphQLEndpoint {
    var baseUrl: String = "https://api.entur.io/journey-planner/v3/graphql"
}

final class JourneyPlannerService {
    let journeyPlannerEndpoint = JourneyPlannerEndpoint()
    
    func fetchStopData(stopPlaceID: String) async throws -> [JourneyPlannerStopMetadata] {
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
                    transportMode
                  }
                }
              }
            }
            """

        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(for: journeyPlannerEndpoint.makeRequest(with: query))
        } catch {
            throw EndpointError.networkError(error)
        }

        try journeyPlannerEndpoint.validateHTTPResponse(response)
        
        let decoded: GraphQLData<JourneyPlannerResponse>
        
        do {
            decoded = try JSONDecoder().decode(GraphQLData<JourneyPlannerResponse>.self, from: data)
        } catch {
            throw EndpointError.decodingError(error)
        }
        
        // TODO: safely unwrap optionals
        return decoded.data.stopPlace.estimatedCalls.map {
            JourneyPlannerStopMetadata(
                publicCode: $0.serviceJourney.journeyPattern.line.publicCode,
                frontText: $0.destinationDisplay.frontText,
                transportType: TransportType($0.serviceJourney.transportMode!, queryType: .journeyPlanner)!
            )
        }
    }
    
    func fetchLiveArrivalData(stopPlaceID: String) async throws -> [JourneyPlannerArrivalData]{
        let query = """
            {
              stopPlace(id: "\(stopPlaceID)") {
                estimatedCalls(
                  numberOfDeparturesPerLineAndDestinationDisplay: 8
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
                  aimedDepartureTime
                  expectedDepartureTime
                }
              }
            }
            """
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(for: journeyPlannerEndpoint.makeRequest(with: query))
        } catch {
            throw EndpointError.networkError(error)
        }

        try journeyPlannerEndpoint.validateHTTPResponse(response)
        
        let decoded: GraphQLData<JourneyPlannerResponse>
        
        do {
            decoded = try JSONDecoder().decode(GraphQLData<JourneyPlannerResponse>.self, from: data)
        } catch {
            throw EndpointError.decodingError(error)
        }
        
        // TODO: safely unwrap optionals
        return decoded.data.stopPlace.estimatedCalls.map {
            JourneyPlannerArrivalData(
                publicCode: $0.serviceJourney.journeyPattern.line.publicCode,
                frontText: $0.destinationDisplay.frontText,
                aimedDepartureTime: $0.aimedDepartureTime!,
                expectedDepartureTime: $0.expectedDepartureTime!,
            )
        }
    }
}
