//
//  RestaurantsApiClient.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 20.12.21.
//

import Foundation
 
protocol RestaurantsApiClientProtocol {
    func fetchRestaurants(term: String,
                          latitude: Double,
                          longitude: Double,
                          completion: @escaping (Result<[Restaurant], Error>) -> Void)

    func fetchRestaurantDetails(id: String, completion: @escaping (Result<Restaurant, Error>) -> Void)

    func fetchRestaurantReviews(id: String, completion: @escaping (Result<[RestaurantReview], Error>) -> Void)
}

class RestaurantsApiClient: RestaurantsApiClientProtocol {

    private let baseUrl: String
    private let apiKey: String

    private let searchRestaurantsPath = "/businesses/search"
    private let restaurantDetailsPath = "/businesses"
    private let restaurantReviewsPath = "/businesses"

    init(baseUrl: String = "https://api.yelp.com/v3", apiKey: String) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }

    // MARK: RestaurantsApiClientProtocol

    func fetchRestaurants(term: String,
                          latitude: Double,
                          longitude: Double,
                          completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        // setup http headers
        let httpHeaders = setupHTTPHeaders(apiKey: apiKey,
                                           contentType: "Application/json")
        // setup query parameters
        let queryParams = setupQueryParams(term: term,
                                           latitude: latitude,
                                           longitude: longitude)
        do {
            // create url request
            let urlRequest = try ApiClientUtils.createUrlRequest(baseUrl: baseUrl,
                                                                 path: searchRestaurantsPath,
                                                                 headers: httpHeaders,
                                                                 queryParams: queryParams)

            // execute url request
            URLSession.shared.jsonDecodableTask(with: urlRequest) { (result: Result<BusinessesResponseDTO, Error>) in
                switch result {
                case .success(let businessesDTO):
                    // extract only restaurants from the response dto
                    let restaurants = businessesDTO.businesses
                    completion(.success(restaurants ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }.resume()
        } catch let error {
            completion(.failure(error))
        }
    }

    func fetchRestaurantDetails(id: String, completion: @escaping (Result<Restaurant, Error>) -> Void) {
        let path = "\(restaurantDetailsPath)/\(id)"

        // setup http headers
        let httpHeaders = setupHTTPHeaders(apiKey: apiKey,
                                           contentType: "Application/json")

        do {
            // create url request
            let urlRequest = try ApiClientUtils.createUrlRequest(baseUrl: baseUrl,
                                                                 path: path,
                                                                 headers: httpHeaders,
                                                                 queryParams: [:])
            // execute url request
            URLSession.shared.jsonDecodableTask(with: urlRequest) { (result: Result<Restaurant, Error>) in
                switch result {
                case .success(let restaurantDetail):
                    completion(.success(restaurantDetail))
                case .failure(let error):
                    completion(.failure(error))
                }
            }.resume()
        } catch let error {
            completion(.failure(error))
        }
    }

    func fetchRestaurantReviews(id: String, completion: @escaping (Result<[RestaurantReview], Error>) -> Void) {
        let path = "\(restaurantReviewsPath)/\(id)/reviews"

        // setup http headers
        let httpHeaders = setupHTTPHeaders(apiKey: apiKey,
                                           contentType: "Application/json")

        do {
            // create url request
            let urlRequest = try ApiClientUtils.createUrlRequest(baseUrl: baseUrl,
                                                                 path: path,
                                                                 headers: httpHeaders,
                                                                 queryParams: [:])
            // execute url request
            URLSession.shared.jsonDecodableTask(with: urlRequest) { (result: Result<RestaurantReviewsDTO, Error>) in
                switch result {
                case .success(let restaurantReviewsDTO):
                    // extract only reviews from the response dto
                    let reviews = restaurantReviewsDTO.reviews
                    completion(.success(reviews ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }.resume()
        } catch let error {
            completion(.failure(error))
        }
    }

    // MARK: Private

    private func setupHTTPHeaders(apiKey: String,
                                 contentType: String) -> [String: String] {
        return ["Authorization": "Bearer \(apiKey)",
                "Content-type": contentType]
    }

    private func setupQueryParams(term: String,
                                 latitude: Double,
                                 longitude: Double) -> [String: String] {
        return ["term": term,
                "latitude": "\(latitude)",
                "longitude": "\(longitude)"]
    }
}
