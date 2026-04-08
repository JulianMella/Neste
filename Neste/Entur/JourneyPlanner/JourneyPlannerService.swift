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

struct JourneyPlannerService {
    let journeyPlannerEndpoint = JourneyPlannerEndpoint()
    let formatter = ISO8601DateFormatter()
    
    func fetchStopData(stopPlaceID: String) async throws -> [JourneyPlannerStopMetadata] {
        // supportedRegions is a VERY basic solution for supporting other regions
        // I will not give this much thought unless the app gains popularity
        let query = """
            {
              stopPlace(id: "\(stopPlaceID)") {
                estimatedCalls(
                    numberOfDeparturesPerLineAndDestinationDisplay: 1
                  numberOfDepartures: 100
                  whiteListed: {authorities: ["\(supportedRegions.authorities["Oslo"] ?? "RUT:Authority:RUT")"]}
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
        
        return decoded.data.stopPlace.estimatedCalls.compactMap { call -> JourneyPlannerStopMetadata? in
            guard let transportMode = call.serviceJourney.transportMode,
                    let transportType = TransportType(transportMode, queryType: .journeyPlanner)
            else {
                return nil
            }
            
            return JourneyPlannerStopMetadata(
                publicCode: call.serviceJourney.journeyPattern.line.publicCode,
                frontText: call.destinationDisplay.frontText,
                transportType: transportType
            )
        }
    }
    
    func fetchLiveArrivalData(stopPlaceID: String) async throws -> [JourneyPlannerArrivalData]{
        // supportedRegions is a VERY basic solution for supporting other regions
        // I will not give this much thought unless the app gains popularity
        let query = """
            {
              stopPlace(id: "\(stopPlaceID)") {
                estimatedCalls(
                  numberOfDeparturesPerLineAndDestinationDisplay: 8
                  numberOfDepartures: 100
                  whiteListed: {authorities: ["\(supportedRegions.authorities["Oslo"] ?? "RUT:Authority:RUT")"]}
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
        
        return decoded.data.stopPlace.estimatedCalls.compactMap { call -> JourneyPlannerArrivalData? in
            guard let aimed = call.aimedDepartureTime,
                      let expected = call.expectedDepartureTime,
                      let aimedDepartureTime = formatter.date(from: aimed),
                      let expectedDepartureTime = formatter.date(from: expected)
            else { return nil }
            
            return JourneyPlannerArrivalData(
                publicTransportNumber: call.serviceJourney.journeyPattern.line.publicCode,
                finalDestination: call.destinationDisplay.frontText,
                aimedDepartureTime: aimedDepartureTime,
                expectedDepartureTime: expectedDepartureTime,
            )
        }
    }
}
