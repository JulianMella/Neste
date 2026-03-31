//
//  Endpoint.swift
//  RuterMenuBar
//
//  Created by Julian on 30/03/2026.
//

protocol Endpoint {
    var url: String { get }
    var etClientHeader: String { get }
    var clientName: String { get }
}

// Entur API requires identification through the header ET-Client
extension Endpoint {
    var etClientHeader: String {"ET-Client-Header"}
    var clientName: String {"julianmella-neste"}
}


