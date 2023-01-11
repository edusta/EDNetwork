//
//  StubEndpoint.swift
//  EDNetworkTests
//
//  Created by Engin Deniz Usta on 06.01.23.
//

import Foundation

@testable import EDNetwork

enum StubEndpoint: String, EDEndpoint {
    case posts

    var path: String { "/" + rawValue }
    var method: EDEndpointMethod { .GET }
}
