//
//  Error+Extensions.swift
//  EDNetwork
//
//  Created by Engin Deniz Usta on 10.01.23.
//

import Foundation

extension Error {
    var toNetworkError: EDNetworkError {
        switch self {
        case let error as EDNetworkError:
            return error
        case let error as DecodingError:
            return .parsingError(error)
        default:
            return .custom(self)
        }
    }
}
