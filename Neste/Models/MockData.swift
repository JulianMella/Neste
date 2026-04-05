//
//  MockData.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

class MockData {
    static let favoriteStops: [FavoriteStop] = [
        FavoriteStop(
            location: "Bislett",
            lines: [
                FavoriteStop.Line(
                    publicTransportNumber: "21",
                    transportType: .bus,
                    finalDestination: "Tjuvholmen",
                    upcomingArrivals: [
                        "5 min",
                        "8 min",
                        "14:15",
                        "18:16",
                    ]
                ),
                FavoriteStop.Line(
                    publicTransportNumber: "21",
                    transportType: .bus,
                    finalDestination: "Helsfyr",
                    upcomingArrivals: [
                        "Nå",
                        "3 min",
                        "12 min",
                        "13:12",
                    ]
                ),
                FavoriteStop.Line(
                    publicTransportNumber: "17",
                    transportType: .tram,
                    finalDestination: "Rikshospitalet",
                    upcomingArrivals: [
                        "5 min",
                        "8 min",
                        "9:15",
                        "11:16",
                    ]
                ),
                FavoriteStop.Line(
                    publicTransportNumber: "17",
                    transportType: .tram,
                    finalDestination: "Sinsen-Grefsen",
                    upcomingArrivals: [
                        "11 min",
                        "13:14",
                        "15:16",
                        "18:20",
                    ]
                )
            ]
        )
    ]
    
    static let addFavoriteResults: [FavoriteStop.Line] = [
        FavoriteStop.Line(
            publicTransportNumber: "12",
            transportType: .tram,
            finalDestination: "Majorstuen",
            upcomingArrivals: []
        ),
        FavoriteStop.Line(
            publicTransportNumber: "21",
            transportType: .bus,
            finalDestination: "Tjuvholmen",
            upcomingArrivals: []
        ),
        FavoriteStop.Line(
            publicTransportNumber: "2",
            transportType: .metro,
            finalDestination: "Stovner",
            upcomingArrivals: []
        )
    ]
}
