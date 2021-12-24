//
//  RestaurantsRepository.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 21.12.21.
//

import Foundation

protocol RestaurantsRepositoryProtocol {
    
    /// Fetch restaurants for the given search query, nearby the given geo location.
    func fetchRestaurants(term: String,
                          latitude: Double,
                          longitude: Double,
                          limit: Int,
                          completion: @escaping (Result<[Restaurant], Error>) -> Void)
    
    /// Save the given restaurant as favorite
    func addFavorite(restaurant: Restaurant,
                     completion: ((Bool) -> Void))

    // Remove the given restaurant from favorites
    func removeFavorite(restaurant: Restaurant,
                        completion: ((Bool) -> Void))
    
    /// Load persisted favorites from disk
    func loadFavorites(completion: ([Restaurant]?) -> Void)
    
    /// Persist favorites on disk
    func persistFavorites(_ restaurants: [Restaurant],
                          completion: ((Bool) -> Void))
}

class RestaurantsRepository: RestaurantsRepositoryProtocol {

    private let apiClient: RestaurantsApiClientProtocol
    private let restaurantsPersistence: RestaurantsPersistenceProtocol

    private let restaurantsPersistenceKey = "restaurants-persistence-key"

    required init(apiClient: RestaurantsApiClientProtocol,
                  restaurantsPersistence: RestaurantsPersistenceProtocol) {
        self.apiClient = apiClient
        self.restaurantsPersistence = restaurantsPersistence
    }

    func fetchRestaurants(term: String,
                          latitude: Double,
                          longitude: Double,
                          limit: Int,
                          completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        apiClient.fetchRestaurants(term: term,
                                   latitude: latitude,
                                   longitude: longitude) { [weak self] result in
            switch result {
            case .success(let restaurants):
                // filter only the array members so as not to exceed the limit
                let filteredArray = self?.getFirstNElements(limit, in: restaurants) ?? []
                completion(.success(filteredArray))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getFirstNElements(_ n: Int, in array: [Restaurant]) -> [Restaurant] {
        guard array.count >= n else {
            // if array is less in length compared to the limit then return the complete array
            return array
        }

        var arraySlice: [Restaurant] = []
        for i in 0 ..< n {
            // fill the new array with elements from the given array,
            // making sure we do not exceed the limit
            arraySlice.append(array[i])
        }

        return arraySlice
    }
    
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
            }
        }
    }
    
    func removeFavorite(restaurant: Restaurant,
                        completion: ((Bool) -> Void)) {
        loadFavorites { restaurants in
            var restaurants = restaurants

            // remove the given restaurant object from the favorite restaurants array
            restaurants?.removeAll(where: { $0.id == restaurant.id })

            // persist the modified favorites array
            persistFavorites(restaurants ?? []) { result in
                completion(result)
            }
        }
    }
    
    func loadFavorites(completion: ([Restaurant]?) -> Void) {
        do {
            let restaurants = try restaurantsPersistence.loadRestaurants(key: restaurantsPersistenceKey)
            completion(restaurants)
        } catch {
            completion(nil)
        }
    }
    
    func persistFavorites(_ restaurants: [Restaurant],
                          completion: ((Bool) -> Void)) {
        do {
            let result = try restaurantsPersistence.saveRestaurants(key: restaurantsPersistenceKey,
                                                                    restaurants: restaurants)
            completion(result)
        } catch {
            completion(false)
        }
    }
}
