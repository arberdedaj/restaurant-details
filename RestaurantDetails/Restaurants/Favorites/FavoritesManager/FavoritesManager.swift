//
//  FavoritesManager.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 24.12.21.
//

import Foundation

class FavoritesManager {

    static let favoritesListChangedNotification = Notification.Name("favoritesListChanged")

    private let favoritesPersistence: FavoritesPersistenceProtocol

    private let favoritesPersistenceKey = "favorites-persistence-key"

    required init(favoritesPersistence: FavoritesPersistenceProtocol) {
        self.favoritesPersistence = favoritesPersistence
    }

    /// Save the given restaurant as favorite
    func addFavorite(restaurant: Restaurant,
                     completion: ((Bool) -> Void)) {
        // load all existing favorites first
        loadFavorites { restaurants in
            var restaurants = restaurants
            // if we have no persisted favorites yet,
            // ensure we have an allocated array to work with
            if restaurants == nil {
                restaurants = []
            }

            // check if the given restaurant is already favorite
            guard var restaurants = restaurants,
            !restaurants.contains(where: { $0.id == restaurant.id }) else {
                completion(false)
                return
            }

            // append restaurant in the favorite restaurants array
            restaurants.append(restaurant)

            // persist favorite restaurants array
            persistFavorites(restaurants) { result in
                completion(result)
                // notify observers that the favorites list has changed
                NotificationCenter.default.post(name: type(of: self).favoritesListChangedNotification,
                                                object: nil)
            }
        }
    }

    /// Remove the given restaurant from favorites
    func removeFavorite(restaurant: Restaurant,
                        completion: ((Bool) -> Void)) {
        loadFavorites { restaurants in
            var restaurants = restaurants
            // if we have no persisted favorites yet,
            // ensure we have an allocated array to work with
            if restaurants == nil {
                restaurants = []
            }

            // check if the given restaurant is already favorite
            guard var restaurants = restaurants,
            restaurants.contains(where: { $0.id == restaurant.id }) else {
                completion(false)
                return
            }

            // remove the given restaurant object from the favorite restaurants array
            restaurants.removeAll(where: { $0.id == restaurant.id })

            // persist the modified favorites array
            persistFavorites(restaurants) { result in
                completion(result)
                // notify observers that the favorites list has changed
                NotificationCenter.default.post(name: type(of: self).favoritesListChangedNotification,
                                                object: nil)
            }
        }
    }

    /// Returns true if restaurant is favorite, otherwise false.
    func isFavorite(restaurant: Restaurant) -> Bool {
        do {
            let restaurants = try favoritesPersistence.loadFavorites(key: favoritesPersistenceKey)
            return restaurants?.contains { $0.id == restaurant.id } ?? false
        } catch {
            return false
        }
    }
    
    /// Load persisted favorites from disk
    func loadFavorites(completion: ([Restaurant]?) -> Void) {
        do {
            let restaurants = try favoritesPersistence.loadFavorites(key: favoritesPersistenceKey)
            completion(restaurants)
        } catch {
            completion(nil)
        }
    }
    
    /// Persist favorites on disk
    func persistFavorites(_ restaurants: [Restaurant],
                          completion: ((Bool) -> Void)) {
        do {
            let result = try favoritesPersistence.saveFavorites(key: favoritesPersistenceKey,
                                                                    restaurants: restaurants)
            completion(result)
        } catch {
            completion(false)
        }
    }
}
