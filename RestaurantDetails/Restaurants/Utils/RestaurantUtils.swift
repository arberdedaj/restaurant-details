//
//  RestaurantUtils.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 26.12.21.
//

import Foundation

class RestaurantUtils {

    static func getFormattedRestaurantAddress(_ restaurant: Restaurant) -> String? {
        guard let displayAddress = restaurant.location?.displayAddress,
              displayAddress.count >= 2 else {
                  return nil
              }
        
        return "\(displayAddress[0]), \(displayAddress[1])"
    }
}
