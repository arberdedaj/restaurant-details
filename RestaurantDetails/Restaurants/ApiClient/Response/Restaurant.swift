//
//  Restaurant.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 20.12.21.
//

import Foundation

class Restaurant: Codable {
    let id: String?
    let name: String?
    let imageUrl: String?
    let location: RestaurantLocation?
    let rating: Double?
    let photos: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, location, rating, photos
        case imageUrl = "image_url"
    }
}

class RestaurantLocation: Codable {
    let displayAddress: [String]?

    enum CodingKeys: String, CodingKey {
        case displayAddress = "display_address"
    }
}
