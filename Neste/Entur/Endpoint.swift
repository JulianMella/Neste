//
//  Endpoint.swift
//  RuterMenuBar
//
//  Created by Julian on 30/03/2026.
//
import Foundation

protocol Endpoint {
    var url: String { get }
    var etClientHeader: String { get }
    var clientName: String { get }
}

// Entur API requires identification through the header ET-Client
extension Endpoint {
    var etClientHeader: String {"ET-Client-Name"}
    var clientName: String {"julianmella-neste"}
    
    func makeRequest(_ query: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url + query)!)
        request.setValue(clientName, forHTTPHeaderField: etClientHeader)
        return request
    }
}


