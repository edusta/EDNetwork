//
//  EDEndpoint.swift
//  EDNetwork
//
//  Created by Engin Deniz Usta on 06.01.23.
//

import Foundation

public protocol EDEndpoint {
    var path: String { get }
    var method: EDEndpointMethod { get }
}
