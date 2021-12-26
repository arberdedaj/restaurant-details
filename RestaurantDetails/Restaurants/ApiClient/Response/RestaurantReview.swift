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

    init(id: String?, text: String?, rating: Int?, user: ReviewUser?) {
        self.id = id
        self.text = text
        self.rating = rating
        self.user = user
    }
}

class ReviewUser: Codable {
    let id: String?
    let name: String?
    let imageUrl: String?

    init(id: String?, name: String?, imageUrl: String?) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "image_url"
    }
}
