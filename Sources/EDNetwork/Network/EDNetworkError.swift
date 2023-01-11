//
//  EDNetworkError.swift
//  EDNetwork
//
//  Created by Engin Deniz Usta on 05.01.23.
//

import Foundation

public enum EDNetworkError: LocalizedError {
    case invalidURL
    case invalidData
    case invalidResponse
    case badResponse(_ statusCode: Int)
    case parsingError(_ error: DecodingError)
    case custom(_ error: Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidData:
            return "Invalid data."
        case .invalidResponse:
            return "Invalid response."
        case let .badResponse(statusCode):
            return "Bad response with status code: \(statusCode)"
        case let .parsingError(error):
            return error.localizedDescription
        case let .custom(error):
            return error.localizedDescription
        }
    }
}
