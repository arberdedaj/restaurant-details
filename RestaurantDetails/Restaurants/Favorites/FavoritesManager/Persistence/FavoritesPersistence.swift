//
//  FavoritesPersistence.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 21.12.21.
//

import Foundation

protocol FavoritesPersistenceProtocol {

    /// Save restaurants in File storage
    /// - Parameters:
    ///   - key: The key with which to associate the favorites array.
    ///   - restaurants: The favorites array to be saved.
    func saveFavorites(key: String, restaurants: [Restaurant]) throws -> Bool

    /// Load favorites from File storage
    /// - Parameter key: The key with which to load the favorites from.
    func loadFavorites(key: String) throws -> [Restaurant]?

    /// Delete favorites from File storage
    /// - Parameter key: The key with which to delete the favorites from.
    func deleteFavorites(key: String) throws -> Bool
}

class FavoritesPersistence: FavoritesPersistenceProtocol {

    private let storage: StorageProtocol

    required init(storage: StorageProtocol) {
        self.storage = storage
    }

    func saveFavorites(key: String, restaurants: [Restaurant]) throws -> Bool {
        return try storage.save(restaurants, for: key)
    }
    
    func loadFavorites(key: String) throws -> [Restaurant]? {
        return try storage.read([Restaurant].self, for: key)
    }
    
    func deleteFavorites(key: String) throws -> Bool {
        return try storage.delete(for: key)
    }
}
