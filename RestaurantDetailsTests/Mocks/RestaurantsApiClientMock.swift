//
//  RestaurantsApiClientMock.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import Foundation
@testable import RestaurantDetails

class ReataurantsApiClientMock: RestaurantsApiClientProtocol {

    /// Use keywords: "success" or "error" as a value
    private let behaviour: String

    init(behaviour: String) {
        self.behaviour = behaviour
    }
    
    func fetchRestaurants(term: String,
                          latitude: Double,
                          longitude: Double,
                          completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        if isBehaviourSuccess() {
            completion(.success(RestaurantsMock.restaurants))
        } else {
            let error = createError("Failed to fetch restaurants",
                                    reason: "Reason unknown",
                                    fromClass: type(of: self),
                                    code: 0)
            completion(.failure(error))
        }
    }
    
    func fetchRestaurantDetails(id: String, completion: @escaping (Result<Restaurant, Error>) -> Void) {
        if isBehaviourSuccess() {
            let restaurant = Restaurant(id: "example_id", name: "example_name",
                                        imageUrl: nil, location: nil,
                                        rating: nil, photos: ["example_url1", "example_url_2"])
            completion(.success(restaurant))
        } else {
            let error = createError("Failed to fetch restaurant details",
                                    reason: "Reason unknown",
                                    fromClass: type(of: self),
                                    code: 0)
            completion(.failure(error))
        }
    }
    
    func fetchRestaurantReviews(id: String, completion: @escaping (Result<[RestaurantReview], Error>) -> Void) {
        if isBehaviourSuccess() {
            completion(.success(RestaurantsMock.reviews))
        } else {
            let error = createError("Failed to fetch reviews",
                                    reason: "Reason unknown",
                                    fromClass: type(of: self),
                                    code: 0)
            completion(.failure(error))
        }
    }

    private func isBehaviourSuccess() -> Bool {
        return behaviour == "success"
    }

    private func createError(_ message: String,
                             reason: String,
                             fromClass className: AnyClass,
                             code: Int? = nil) -> Error {
        let className = String(describing: className.self)
        let description = "\(message): <\(reason)>"
        let stackTrace = "\(String(describing: type(of: Error.self))) from <\(className)>"
        let debugDescription = "\(description). \(stackTrace)"
        let errorInfo: [String: Any] = [NSLocalizedDescriptionKey: description,
                                        NSLocalizedFailureReasonErrorKey: reason,
                                        NSDebugDescriptionErrorKey: debugDescription]
        let bundle = Bundle.main
        let bundleIdentifier = bundle.bundleIdentifier
        return NSError(domain: bundleIdentifier ?? "",
                       code: code ?? 0,
                       userInfo: errorInfo)
    }
}
