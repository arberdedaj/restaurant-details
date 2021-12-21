//
//  RestaurantsPersistence.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 21.12.21.
//

import Foundation

protocol RestaurantsPersistenceProtocol {

    /// Save restaurants in File storage
    /// - Parameters:
    ///   - key: The key with which to associate the restaurants array.
    ///   - restaurants: The restaurants array to be saved.
    func saveRestaurants(key: String, restaurants: [Restaurant]) throws -> Bool

    /// Load restaurants from File storage
    /// - Parameter key: The key with which to load the restaurants from.
    func loadRestaurants(key: String) throws -> [Restaurant]?

    /// Delete restaurants from File storage
    /// - Parameter key: The key with which to delete the restaurants from.
    func deleteRestaurants(key: String) throws -> Bool
}

class RestaurantsPersistence: RestaurantsPersistenceProtocol {

    private let storage: StorageProtocol

    required init(storage: StorageProtocol) {
        self.storage = storage
    }

    func saveRestaurants(key: String, restaurants: [Restaurant]) throws -> Bool {
        return try storage.save(restaurants, for: key)
    }
    
    func loadRestaurants(key: String) throws -> [Restaurant]? {
        return try storage.read([Restaurant].self, for: key)
    }
    
    func deleteRestaurants(key: String) throws -> Bool {
        return try storage.delete(for: key)
    }
}
