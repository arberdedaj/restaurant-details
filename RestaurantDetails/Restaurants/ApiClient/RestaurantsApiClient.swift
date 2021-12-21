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
}

class RestaurantsApiClient: RestaurantsApiClientProtocol {

    private let baseUrl: String
    private let apiKey: String

    let searchRestaurantsPath = "/businesses/search"

    init(baseUrl: String = "https://api.yelp.com/v3", apiKey: String) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }

    func fetchRestaurants(term: String,
                          latitude: Double,
                          longitude: Double,
                          completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        do {
            // setup http headers
            let httpHeaders = setupHTTPHeaders(apiKey: apiKey,
                                               contentType: "Application/json")
            // setup query parameters
            let queryItems = setupQueryItems(term: term,
                                             latitude: latitude,
                                             longitude: longitude)
            // create url request
            let urlRequest = try createUrlRequest(baseUrl: baseUrl,
                                                  path: searchRestaurantsPath,
                                                  headers: httpHeaders,
                                                  queryParams: queryItems)

            // execute url request
            URLSession.shared.jsonDecodableTask(with: urlRequest) { (result: Result<BusinessesResponseDTO, Error>) in
                switch result {
                case .success(let businessesDTO):
                    // extract only restaurants from the response dto
                    let restaurants = businessesDTO.businesses
                    completion(.success(restaurants))
                case .failure(let error):
                    completion(.failure(error))
                }
            }.resume()
        } catch let error {
            completion(.failure(error))
        }
    }

    private func setupHTTPHeaders(apiKey: String,
                                  contentType: String) -> [AnyHashable: Any] {
        return ["Authorization": "Bearer \(apiKey)",
                "Content-type": contentType]
    }

    private func setupQueryItems(term: String,
                                 latitude: Double,
                                 longitude: Double) -> [String: String] {
        return ["term": term,
                "latitude": "\(latitude)",
                "longitude": "\(longitude)"]
    }

    private func createUrlRequest(baseUrl: String,
                                  path: String,
                                  headers: [AnyHashable: Any],
                                  queryParams: [String: String]) throws -> URLRequest {
        guard var components = URLComponents(string: baseUrl) else {
            let error = NSError(domain: Bundle.main.bundleIdentifier ?? "",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Could not load restaurants",
                                    NSLocalizedFailureReasonErrorKey: "The provided baseUrl is not valid"])
            throw error
        }
        components.path = components.path.appending(path)
        components.queryItems = queryParams.compactMap { URLQueryItem(name: $0.key,
                                                                      value: $0.value) }
        
        if let url = components.url {
            var request  = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("Application/json", forHTTPHeaderField: "Content-type")
            return request
        } else {
            let error = NSError(domain: Bundle.main.bundleIdentifier ?? "",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Could not load restaurants",
                                    NSLocalizedFailureReasonErrorKey: "Url components are invalid"])
            throw error
        }
    }
}
