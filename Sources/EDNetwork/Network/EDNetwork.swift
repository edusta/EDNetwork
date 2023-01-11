//
//  EDNetwork.swift
//  EDNetwork
//
//  Created by Engin Deniz Usta on 05.01.23.
//

import Foundation
import Combine

public class EDNetwork {
    private let session: URLSession
    private let requestConverter = EDRequestConverter()
    private let jsonDecoder = JSONDecoder()

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func sendRequest<T: Decodable>(_ request: EDRequest) -> AnyPublisher<T, EDNetworkError> {
        do {
            let urlRequest = try requestConverter.constructURLRequest(from: request)
            return session
                .dataTaskPublisher(for: urlRequest)
                .tryMap(transformResult(_:))
                .decode(type: T.self, decoder: jsonDecoder)
                .mapError({ $0.toNetworkError })
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error.toNetworkError).eraseToAnyPublisher()
        }
    }

    public func sendRequest<T: Decodable>(_ request: EDRequest) async -> Result<T, EDNetworkError> {
        do {
            let urlRequest = try requestConverter.constructURLRequest(from: request)
            let result = try await session.data(for: urlRequest)
            let data = try transformResult(result)
            let decodedData = try jsonDecoder.decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error.toNetworkError)
        }
    }

    public func sendRequest<T: Decodable>(_ request: EDRequest,
                                          completionHandler: @escaping ((Result<T, EDNetworkError>) -> Void)) {
        do {
            let urlRequest = try requestConverter.constructURLRequest(from: request)
            session.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let self else { return completionHandler(.failure(.invalidData)) }

                if let error = error {
                    return completionHandler(.failure(error.toNetworkError))
                }
                guard let data = data else {
                    return completionHandler(.failure(.invalidData))
                }
                guard let response = response else {
                    return completionHandler(.failure(.invalidResponse))
                }
                do {
                    let data = try self.transformResult((data, response))
                    let decodedData = try self.jsonDecoder.decode(T.self, from: data)
                    return completionHandler(.success(decodedData))
                } catch {
                    return completionHandler(.failure(error.toNetworkError))
                }
            }.resume()
        } catch {
            return completionHandler(.failure(error.toNetworkError))
        }
    }
}

private extension EDNetwork {
    func transformResult(_ result: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = result.response as? HTTPURLResponse else {
            throw EDNetworkError.invalidResponse
        }
        let statusCode = httpResponse.statusCode
        guard 200...300 ~= statusCode else {
            throw EDNetworkError.badResponse(statusCode)
        }
        return result.data
    }
}
