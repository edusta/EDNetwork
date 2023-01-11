//
//  EDRequestConverterTests.swift
//  EDNetworkTests
//
//  Created by Engin Deniz Usta on 10.01.23.
//

import XCTest
import Nimble
@testable import EDNetwork

final class EDRequestConverterTests: XCTestCase {
    private let requestConverter = EDRequestConverter()
    private let jsonEncoder = JSONEncoder()

    private let data = StubCodableData(id: "1", name: "Engin")
    private let url = URL(string: "https://edusta.dev")!
    private let headers = ["Content-Type": "application/json", "Authorization": "Bearer X"]
    private let queryItems = ["image_id": "5"]

    func testURLRequestGeneration() throws {
        let requestData = StubRequestData(data: data, headers: headers, queryItems: queryItems)
        let request = StubRequest(url: url, endpoint: StubEndpoint.posts, requestData: requestData)

        let convertedRequest = try requestConverter.constructURLRequest(from: request)
        expect(convertedRequest.url?.absoluteString) == expectedURLString
        expect(convertedRequest.httpBody) == expectedData
        expect(convertedRequest.allHTTPHeaderFields) == headers
        expect(convertedRequest.httpMethod) == "GET"
    }
}

private extension EDRequestConverterTests {
    var expectedURLString: String { "https://edusta.dev/posts?image_id=5" }
    var expectedData: Data? { try? jsonEncoder.encode(data) }
}
