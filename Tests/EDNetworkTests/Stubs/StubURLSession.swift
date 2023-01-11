//
//  StubURLSession.swift
//  EDNetworkTests
//
//  Created by Engin Deniz Usta on 05.01.23.
//

import Foundation

class StubURLSession {
    static let shared: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [StubURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
}
