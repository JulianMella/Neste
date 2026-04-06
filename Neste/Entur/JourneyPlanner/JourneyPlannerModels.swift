//
//  JourneyPlannerModels.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

import Foundation

// Flattened structs based upon JourneyPlannerResponse data
struct JourneyPlannerStopMetadata: Hashable {
    var publicCode: String
    var frontText: String
    var transportType: TransportType
}

struct JourneyPlannerArrivalData: Hashable {
    var publicCode: String
    var frontText: String
    var aimedDepartureTime: String
    var expectedDepartureTime: String
}

struct GraphQLData<T: Decodable>: Decodable {
    var data: T
}

struct JourneyPlannerResponse: Decodable {
    var stopPlace: JourneyPlannerStopPlace
}

struct JourneyPlannerStopPlace: Decodable {
    var estimatedCalls: [JourneyPlannerEstimatedCall]
}

struct JourneyPlannerEstimatedCall: Decodable {
    var destinationDisplay: JourneyPlannerDestinationDisplay
    var serviceJourney: JourneyPlannerServiceJourney
    // fetchArrivalData() gets these values whilst fetchStopData() doesn't, therefore they are optionals
    var aimedDepartureTime: String?
    var expectedDepartureTime: String?
}

struct JourneyPlannerDestinationDisplay: Decodable {
    var frontText: String
}

struct JourneyPlannerServiceJourney: Decodable {
    var journeyPattern: JourneyPlannerJourneyPattern
    var transportMode: String?
}

struct JourneyPlannerJourneyPattern: Decodable {
    var line: JourneyPlannerLine
}

struct JourneyPlannerLine: Decodable {
    var publicCode: String
}
