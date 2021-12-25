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
    
    /// Fetch restaurant details for the given id.
    func fetchRestaurantDetails(id: String,
                                completion: @escaping (Result<Restaurant, Error>) -> Void)
    
    /// Fetch reviews for the given restaurant id.
    func fetchRestaurantReviews(id: String,
                                completion: @escaping (Result<[RestaurantReview], Error>) -> Void)
}

class RestaurantsRepository: RestaurantsRepositoryProtocol {

    private let apiClient: RestaurantsApiClientProtocol

    required init(apiClient: RestaurantsApiClientProtocol) {
        self.apiClient = apiClient
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

    func fetchRestaurantDetails(id: String,
                                completion: @escaping (Result<Restaurant, Error>) -> Void) {
        apiClient.fetchRestaurantDetails(id: id, completion: completion)
    }

    func fetchRestaurantReviews(id: String,
                                completion: @escaping (Result<[RestaurantReview], Error>) -> Void) {
        apiClient.fetchRestaurantReviews(id: id, completion: completion)
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
}
