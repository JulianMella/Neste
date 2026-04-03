//
//  MockData.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

extension FavoriteStopsModel {
    static let mockData: [FavoriteStop] = [
        FavoriteStop(
            location: "Bislett",
            lines: [
                FavoriteStop.Line(
                    publicTransportNumber: "21",
                    transportType: .bus,
                    finalDestination: "Tjuvholmen",
                    upcomingArrivals: []
                ),
                FavoriteStop.Line(
                    publicTransportNumber: "21",
                    transportType: .bus,
                    finalDestination: "Helsfyr",
                    upcomingArrivals: []
                ),
                FavoriteStop.Line(
                    publicTransportNumber: "17",
                    transportType: .tram,
                    finalDestination: "Rikshospitalet",
                    upcomingArrivals: []
                ),
                FavoriteStop.Line(
                    publicTransportNumber: "17",
                    transportType: .tram,
                    finalDestination: "Sinsen-Grefsen",
                    upcomingArrivals: []
                )
            ]
        )
    ]
}
