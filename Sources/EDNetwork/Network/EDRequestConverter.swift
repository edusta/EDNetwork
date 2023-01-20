//
//  EDRequestConverter.swift
//  EDNetwork
//
//  Created by Engin Deniz Usta on 10.01.23.
//

import Foundation

class EDRequestConverter {
    private let jsonEncoder = JSONEncoder()

    func constructURLRequest(from request: some EDRequest) throws -> URLRequest {
        let url = try constructURL(from: request)
        var urlRequest = URLRequest(url: url)
        let requestData = request.requestData
        urlRequest.allHTTPHeaderFields = requestData.headers
        urlRequest.httpMethod = request.endpoint.method.value
        if let data = requestData.data {
            urlRequest.httpBody = try jsonEncoder.encode(data)
        }

        return urlRequest
    }
}

private extension EDRequestConverter {
    func constructURL(from request: some EDRequest) throws -> URL {
        let url = request.url
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw EDNetworkError.invalidURL
        }

        let requestData = request.requestData
        urlComponents.queryItems = requestData.queryItems?.map({
            URLQueryItem(name: $0, value: $1)
        })
        if !request.endpoint.path.isEmpty {
            urlComponents.path = request.endpoint.path
        }
        guard let constructedURL = urlComponents.url else { throw EDNetworkError.invalidURL }
        return constructedURL
    }
}
