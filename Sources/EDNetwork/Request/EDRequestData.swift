//
//  EDRequestData.swift
//  EDNetwork
//
//  Created by Engin Deniz Usta on 06.01.23.
//

import Foundation

public protocol EDRequestData {
    associatedtype Data: Encodable

    var data: Data? { get }
    var headers: [String: String]? { get }
    var queryItems: [String: String?]? { get }
}
