//
//  RestaurantsMock.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import Foundation
@testable import RestaurantDetails

class RestaurantsMock {

    static let restaurants: [Restaurant] = [Restaurant(id: "1", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "2", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "3", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "4", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "5", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "6", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "7", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "8", name: "example_name",
                                                       imageUrl: nil,
                                                       location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "9", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "10", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "11", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil),
                                            Restaurant(id: "12", name: "example_name",
                                                       imageUrl: nil, location: nil,
                                                       rating: 5, photos: nil)]

    static let reviews: [RestaurantReview] = [RestaurantReview(id: "1", text: "example_review_text",
                                                               rating: 4, user: nil),
                                              RestaurantReview(id: "2", text: "example_review_text",
                                                               rating: 3, user: nil),
                                              RestaurantReview(id: "3", text: "example_review_text",
                                                               rating: 5, user: nil)]
}
