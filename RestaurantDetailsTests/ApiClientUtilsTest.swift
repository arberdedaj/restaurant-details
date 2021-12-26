//
//  ApiClientUtilsTest.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import XCTest
@testable import RestaurantDetails

class ApiClientUtilsTest: XCTestCase {

    func testCreateUrlRequestThrowsErrorIfBaseUrlIsInvalid() {
        do {
            let urlRequest = try ApiClientUtils.createUrlRequest(baseUrl: "bad-$&#$%^base-url",
                                                                 path: "/some/path",
                                                                 headers: [:],
                                                                 queryParams: [:])
            XCTAssertNil(urlRequest)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testCreateUrlRequestThrowsErrorIfPathIsInvalid() {
        do {
            let urlRequest = try ApiClientUtils.createUrlRequest(baseUrl: "http://www.some.url",
                                                                 path: "-",
                                                                 headers: [:],
                                                                 queryParams: [:])
            XCTAssertNil(urlRequest)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testUrlRequestHttpMethodIsGET() {
        do {
            let urlRequest = try ApiClientUtils.createUrlRequest(baseUrl: "http://www.some.url",
                                                                 path: "/some/path",
                                                                 headers: ["key": "value"],
                                                                 queryParams: ["key": "value"])
            XCTAssertEqual(urlRequest.httpMethod,
                           "GET")
        } catch {
            XCTAssertNil(error)
        }
    }

    func testUrlRequestHeadersAreSet() {
        do {
            let urlRequest = try ApiClientUtils.createUrlRequest(baseUrl: "http://www.some.url",
                                                                 path: "/some/path",
                                                                 headers: ["key": "value"],
                                                                 queryParams: ["key": "value"])
            XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["key": "value"])
        } catch {
            XCTAssertNil(error)
        }
    }

    func testCreateUrlRequestReturnsExpectedUrlString() {
        do {
            let urlRequest = try ApiClientUtils.createUrlRequest(baseUrl: "http://www.some.url",
                                                                 path: "/some/path",
                                                                 headers: ["key": "value"],
                                                                 queryParams: ["key": "value"])
            XCTAssertEqual(urlRequest.url?.absoluteString,
                           "http://www.some.url/some/path?key=value")
        } catch {
            XCTAssertNil(error)
        }
    }
}
