//
//  Endpoint.swift
//  RuterMenuBar
//
//  Created by Julian on 30/03/2026.
//
import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var etClientHeader: String { get }
    var clientName: String { get }
}

// Entur API requires identification through the header ET-Client
extension Endpoint {
    var etClientHeader: String {"ET-Client-Name"}
    var clientName: String {Bundle.main.infoDictionary?["ET_CLIENT_NAME"] as? String ?? "unnamed-client"}
    
    func validateHTTPResponse(_ response: URLResponse) throws {
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw EndpointError.httpError(statusCode: http.statusCode)
        }
    }
}

protocol RESTEndpoint: Endpoint {}

extension RESTEndpoint {
    func makeRequest(with query: String) -> URLRequest {
        var request = URLRequest(url: URL(string: baseUrl + query)!)
        request.setValue(clientName, forHTTPHeaderField: etClientHeader)
        return request
    }
}

protocol GraphQLEndpoint: Endpoint {}

extension GraphQLEndpoint {
    func makeRequest(with query: String) -> URLRequest {
        var request = URLRequest(url: URL(string: baseUrl)!)
        request.httpMethod = "POST"
        request.setValue(clientName, forHTTPHeaderField: etClientHeader)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["query": query]) // TODO: Handle this gracefully
        return request
    }
}

enum EndpointError: Error {
    case networkError(Error)
    case httpError(statusCode: Int)
    case decodingError(Error)
    case unknown
}
