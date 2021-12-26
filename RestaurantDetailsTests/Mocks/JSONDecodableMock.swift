//
//  JSONDecodableMock.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import XCTest

class JSONEncoderMock: JSONEncoder {

    override func encode<T>(_ value: T) throws -> Data where T: Encodable {
        return Data(bytes: [1, 2, 3], count: 3)
    }
}

class JSONDecoderMock: JSONDecoder {

    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        return ("example_string_object" as? T)!
    }
}
