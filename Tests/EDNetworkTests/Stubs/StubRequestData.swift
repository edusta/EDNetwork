//
//  StubRequestData.swift
//  EDNetworkTests
//
//  Created by Engin Deniz Usta on 10.01.23.
//

import Foundation
@testable import EDNetwork

struct StubRequestData: EDRequestData {
    let data: StubCodableData?
    let headers: [String: String]?
    let queryItems: [String: String?]?
}
