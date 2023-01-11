//
//  EDRequest.swift
//  EDNetwork
//
//  Created by Engin Deniz Usta on 06.01.23.
//

import Foundation

public protocol EDRequest {
    var url: URL { get }
    var endpoint: any EDEndpoint { get }
    var requestData: any EDRequestData { get }
}
