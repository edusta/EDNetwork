//
//  EDRequest.swift
//  EDNetwork
//
//  Created by Engin Deniz Usta on 06.01.23.
//

import Foundation

public protocol EDRequest {
    associatedtype Endpoint: EDEndpoint

    var url: URL { get }
    var endpoint: Endpoint { get }
    var requestData: any EDRequestData { get }
}
