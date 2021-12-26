//
//  RestaurantsRepositoryTest.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import XCTest
@testable import RestaurantDetails

class RestaurantsRepositoryTest: XCTestCase {

    func testFetchRestaurantsThrowsError() {
        let mockApiClient = ReataurantsApiClientMock(behaviour: "error")
        let restaurantsRepository = RestaurantsRepository(apiClient: mockApiClient)

        restaurantsRepository.fetchRestaurants(term: "dummy_term",
                                               latitude: 35.23,
                                               longitude: 37.42,
                                               limit: 10) { result in
            switch result {
            case .success: break
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

    func testFetchRestaurantsSucceeds() {
        let mockApiClient = ReataurantsApiClientMock(behaviour: "success")
        let restaurantsRepository = RestaurantsRepository(apiClient: mockApiClient)

        restaurantsRepository.fetchRestaurants(term: "dummy_term",
                                               latitude: 35.23,
                                               longitude: 37.42,
                                               limit: 10) { result in
            switch result {
            case .success(let restaurants):
                XCTAssertNotNil(restaurants)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    func testFetchRestaurantsBringsMax10Restaurants() {
        let mockApiClient = ReataurantsApiClientMock(behaviour: "success")
        let restaurantsRepository = RestaurantsRepository(apiClient: mockApiClient)

        restaurantsRepository.fetchRestaurants(term: "dummy_term",
                                               latitude: 35.23,
                                               longitude: 37.42,
                                               limit: 10) { result in
            switch result {
            case .success(let restaurants):
                XCTAssertEqual(restaurants.count, 10)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    func testFetchRestaurantsWith11Limit() {
        let mockApiClient = ReataurantsApiClientMock(behaviour: "success")
        let restaurantsRepository = RestaurantsRepository(apiClient: mockApiClient)

        restaurantsRepository.fetchRestaurants(term: "dummy_term",
                                               latitude: 35.23,
                                               longitude: 37.42,
                                               limit: 11) { result in
            switch result {
            case .success(let restaurants):
                XCTAssertEqual(restaurants.count, 11)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    func testFetchRestaurantDetailsSucceeds() {
        let mockApiClient = ReataurantsApiClientMock(behaviour: "success")
        let restaurantsRepository = RestaurantsRepository(apiClient: mockApiClient)

        restaurantsRepository.fetchRestaurantDetails(id: "example_id") { result in
            switch result {
            case .success(let restaurant):
                XCTAssertNotNil(restaurant)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    func testFetchRestaurantDetailsFails() {
        let mockApiClient = ReataurantsApiClientMock(behaviour: "error")
        let restaurantsRepository = RestaurantsRepository(apiClient: mockApiClient)

        restaurantsRepository.fetchRestaurantDetails(id: "example_id") { result in
            switch result {
            case .success(let restaurant):
                XCTAssertNil(restaurant)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

    func testFetchRestaurantReviewsSucceeds() {
        let mockApiClient = ReataurantsApiClientMock(behaviour: "success")
        let restaurantsRepository = RestaurantsRepository(apiClient: mockApiClient)

        restaurantsRepository.fetchRestaurantReviews(id: "example_id") { result in
            switch result {
            case .success(let reviews):
                XCTAssertNotNil(reviews)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    func testFetchRestaurantReviewsFails() {
        let mockApiClient = ReataurantsApiClientMock(behaviour: "error")
        let restaurantsRepository = RestaurantsRepository(apiClient: mockApiClient)

        restaurantsRepository.fetchRestaurantReviews(id: "example_id") { result in
            switch result {
            case .success(let reviews):
                XCTAssertNil(reviews)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
}
