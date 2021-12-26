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

    init(id: String?,
         name: String?,
         imageUrl: String?,
         location: RestaurantLocation?,
         rating: Double?,
         photos: [String]?) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.location = location
        self.rating = rating
        self.photos = photos
    }

    enum CodingKeys: String, CodingKey {
        case id, name, location, rating, photos
        case imageUrl = "image_url"
    }
}

class RestaurantLocation: Codable {
    let displayAddress: [String]?

    init(displayAddress: [String]?) {
        self.displayAddress = displayAddress
    }

    enum CodingKeys: String, CodingKey {
        case displayAddress = "display_address"
    }
}
