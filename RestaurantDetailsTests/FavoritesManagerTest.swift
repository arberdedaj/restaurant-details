//
//  FavoritesManagerTest.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import XCTest
@testable import RestaurantDetails

class FavoritesManagerTest: XCTestCase {

    func testAddFavoriteReturnsTrue() {
        let favoritesPersistenceMock = FavoritesPersistenceMock(behaviour: "success")
        let favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistenceMock)

        let restaurant = Restaurant(id: "123", name: "example_name",
                                    imageUrl: nil, location: nil,
                                    rating: nil, photos: nil)

        favoritesManager.addFavorite(restaurant: restaurant) { result in
            XCTAssertTrue(result)
        }
    }

    func testAddingAFavoriteWhichAlreadyIs() {
        let favoritesPersistenceMock = FavoritesPersistenceMock(behaviour: "success")
        let favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistenceMock)

        let restaurant = Restaurant(id: "1", name: "example_name",
                                    imageUrl: nil, location: nil,
                                    rating: nil, photos: nil)

        favoritesManager.addFavorite(restaurant: restaurant) { result in
            XCTAssertFalse(result)
        }
    }

    func testRemoveFavoriteReturnsTrue() {
        let favoritesPersistenceMock = FavoritesPersistenceMock(behaviour: "success")
        let favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistenceMock)

        let restaurant = Restaurant(id: "1", name: "example_name",
                                    imageUrl: nil, location: nil,
                                    rating: nil, photos: nil)

        favoritesManager.removeFavorite(restaurant: restaurant) { result in
            XCTAssertTrue(result)
        }
    }

    func testRemoveAFavoriteWhichIsNotFavorite() {
        let favoritesPersistenceMock = FavoritesPersistenceMock(behaviour: "success")
        let favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistenceMock)

        let restaurant = Restaurant(id: "123", name: "example_name",
                                    imageUrl: nil, location: nil,
                                    rating: nil, photos: nil)

        favoritesManager.removeFavorite(restaurant: restaurant) { result in
            XCTAssertFalse(result)
        }
    }

    func testLoadFavoritesSucceeds() {
        let favoritesPersistenceMock = FavoritesPersistenceMock(behaviour: "success")
        let favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistenceMock)

        favoritesManager.loadFavorites { restaurants in
            XCTAssertNotNil(restaurants)
        }
    }

    func testLoadFavoritesFails() {
        let favoritesPersistenceMock = FavoritesPersistenceMock(behaviour: "error")
        let favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistenceMock)

        favoritesManager.loadFavorites { restaurants in
            XCTAssertNil(restaurants)
        }
    }

    func testPersistFavoritesSucceeds() {
        let favoritesPersistenceMock = FavoritesPersistenceMock(behaviour: "success")
        let favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistenceMock)

        let restaurants = RestaurantsMock.restaurants

        favoritesManager.persistFavorites(restaurants) { result in
            XCTAssertTrue(result)
        }
    }

    func testPersistFavoritesFails() {
        let favoritesPersistenceMock = FavoritesPersistenceMock(behaviour: "error")
        let favoritesManager = FavoritesManager(favoritesPersistence: favoritesPersistenceMock)

        let restaurants = RestaurantsMock.restaurants

        favoritesManager.persistFavorites(restaurants) { result in
            XCTAssertFalse(result)
        }
    }
}
