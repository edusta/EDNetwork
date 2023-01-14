//
//  StubRequest.swift
//  EDNetworkTests
//
//  Created by Engin Deniz Usta on 10.01.23.
//

import Foundation
@testable import EDNetwork

struct StubRequest: EDRequest {
    let url: URL
    let endpoint: StubEndpoint
    let requestData: StubRequestData
}
