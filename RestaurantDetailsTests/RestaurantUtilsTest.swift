//
//  RestaurantUtilsTest.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import XCTest
@testable import RestaurantDetails

class RestaurantUtilsTest: XCTestCase {

    func testGetFormattedAddress() {
        let location = RestaurantLocation(displayAddress: ["address_1", "address_2"])
        let restaurant = Restaurant(id: "1", name: "example-name",
                                    imageUrl: nil, location: location,
                                    rating: 5.0, photos: nil)
        let formattedAddress = RestaurantUtils.getFormattedRestaurantAddress(restaurant)
        XCTAssertEqual("address_1, address_2", formattedAddress)
    }
}
