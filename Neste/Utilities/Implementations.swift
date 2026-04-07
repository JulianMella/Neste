//
//  Implementations.swift
//  Neste
//
//  Created by Julian on 07/04/2026.
//

enum supportedRegions {
    static let authorities: [County : Authority] = [
        "Oslo" : "RUT:Authority:RUT"
    ]
}

typealias County = String
typealias Authority = String
