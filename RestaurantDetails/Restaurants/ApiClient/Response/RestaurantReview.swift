//
//  RestaurantReview.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 25.12.21.
//

import Foundation

class RestaurantReview: Codable {
    let id: String?
    let text: String?
    let rating: Int?
    let user: ReviewUser?
}

class ReviewUser: Codable {
    let id: String?
    let name: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "image_url"
    }
}
