//
//  FavoritesPersistenceTest.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import XCTest
@testable import RestaurantDetails

class FavoritesPersistenceTest: XCTestCase {

    func testSaveFavoritesSucceeds() {
        let favoritesPersistence = FavoritesPersistence(storage: StorageMock(behaviour: "success"))
        do {
            let result = try favoritesPersistence.saveFavorites(key: "example-key", restaurants: RestaurantsMock.restaurants)
            XCTAssertTrue(result)
        } catch {
            XCTAssertNil(error)
        }
    }

    func testSaveFavoritesFails() {
        let favoritesPersistence = FavoritesPersistence(storage: StorageMock(behaviour: "error"))
        do {
            let result = try favoritesPersistence.saveFavorites(key: "example-key", restaurants: RestaurantsMock.restaurants)
            XCTAssertFalse(result)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testLoadFavoritesSucceeds() {
        let favoritesPersistence = FavoritesPersistence(storage: StorageMock(behaviour: "success"))
        do {
            let restaurants = try favoritesPersistence.loadFavorites(key: "example-key")
            XCTAssertNotNil(restaurants)
        } catch {
            XCTAssertNil(error)
        }
    }

    func testLoadFavoritesFails() {
        let favoritesPersistence = FavoritesPersistence(storage: StorageMock(behaviour: "error"))
        do {
            let restaurants = try favoritesPersistence.loadFavorites(key: "example-key")
            XCTAssertNil(restaurants)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testDeleteFavoritesSucceeds() {
        let favoritesPersistence = FavoritesPersistence(storage: StorageMock(behaviour: "success"))
        do {
            let result = try favoritesPersistence.deleteFavorites(key: "example-key")
            XCTAssertTrue(result)
        } catch {
            XCTAssertNil(error)
        }
    }

    func testDeleteFavoritesFails() {
        let favoritesPersistence = FavoritesPersistence(storage: StorageMock(behaviour: "error"))
        do {
            let result = try favoritesPersistence.deleteFavorites(key: "example-key")
            XCTAssertFalse(result)
        } catch {
            XCTAssertNotNil(error)
        }
    }

}
