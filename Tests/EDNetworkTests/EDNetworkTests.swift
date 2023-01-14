//
//  EDNetworkTests.swift
//  EDNetworkTests
//
//  Created by Engin Deniz Usta on 05.01.23.
//

import XCTest
import Combine
import Nimble

@testable import EDNetwork

final class EDNetworkTests: XCTestCase {
    private let network = EDNetwork(session: StubURLSession.shared)
    private let encoder = JSONEncoder()
    private var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        super.tearDown()
        cancellables.forEach { $0.cancel() }
    }

    func testFetchPublisherSuccess() throws {
        setSuccessResponse()

        var foundData: StubCodableData!
        publisher.sink { completion in
            if case let .failure(error) = completion {
                fail("Expected data, found: \(error.localizedDescription)")
            }
        } receiveValue: { data in
            foundData = data
        }.store(in: &cancellables)

        expect(foundData).toEventually(equal(expectedData))
    }

    func testFetchPublisherFailure() {
        setFailureResponse()

        var foundError: EDNetworkError!
        publisher.sink { completion in
            if case let .failure(error) = completion {
                foundError = error
            }
        } receiveValue: { data in
            fail("Expected error, found: \(data)")
        }.store(in: &cancellables)

        expect(foundError).toEventuallyNot(beNil())

        switch foundError {
        case let .badResponse(statusCode):
            expect(statusCode) == 404
        default:
            fail("Expected badResponse as error, found: \(String(describing: foundError))")
        }
    }

    func testFetchAsyncSuccess() async throws {
        setSuccessResponse()

        let result = try await fetchAsyncRequest()
        let data = try result.get()
        expect(data) == expectedData
    }

    func testFetchAsyncFailure() async {
        setFailureResponse()

        do {
            let result = try await fetchAsyncRequest()
            let data = try result.get()
            expect(data) == expectedData
        } catch let error as EDNetworkError {
            switch error {
            case let .badResponse(statusCode):
                expect(statusCode) == 404
            default:
                fail("Expected badResponse as error, found: \(error)")
            }
        } catch {
            fail("Expected EDNetworkError as error, found: \(error)")
        }
    }

    func testFetchCompletionBlockSuccess() {
        setSuccessResponse()

        waitUntil { done in
            self.network.sendRequest(self.request) { (result: Result<StubCodableData, EDNetworkError>) in
                switch result {
                case let .success(data):
                    expect(data) == self.expectedData
                case let .failure(error):
                    fail("Expected data, found: \(error)")
                }
                done()
            }
        }
    }

    func testFetchCompletionBlockFailure() {
        setFailureResponse()

        waitUntil { done in
            self.network.sendRequest(self.request) { (result: Result<StubCodableData, EDNetworkError>) in
                switch result {
                case let .success(data):
                    fail("Expected error, found: \(data)")
                case let .failure(error):
                    switch error {
                    case let .badResponse(statusCode):
                        expect(statusCode) == 404
                    default:
                        fail("Expected badResponse as error, found: \(error)")
                    }
                }
                done()
            }
        }
    }
}

private extension EDNetworkTests {
    var expectedData: StubCodableData { StubCodableData(id: "1", name: "Engin") }
    var url: URL { URL(string: "https://edusta.dev")! }
    var requestData: StubRequestData {
        StubRequestData(data: expectedData, headers: nil, queryItems: nil)
    }
    var request: some EDRequest {
        StubRequest(url: url, endpoint: .posts, requestData: requestData)
    }
    var publisher: AnyPublisher<StubCodableData, EDNetworkError> {
        network.sendRequest(request)
    }

    func fetchAsyncRequest() async throws -> Result<StubCodableData, EDNetworkError> {
        await network.sendRequest(request)
    }

    func setSuccessResponse() {
        StubURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            let codableData = StubCodableData(id: "1", name: "Engin")
            let data = try self.encoder.encode(codableData)
            return (response, data)
        }
    }

    func setFailureResponse() {
        StubURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, Data())
        }
    }
}
