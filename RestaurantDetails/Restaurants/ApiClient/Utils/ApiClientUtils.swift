//
//  ApiClientUtils.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 26.12.21.
//

import Foundation

class ApiClientUtils {

    static func createUrlRequest(baseUrl: String,
                                 path: String,
                                 headers: [String: String],
                                 queryParams: [String: String]) throws -> URLRequest {
        guard var components = URLComponents(string: baseUrl) else {
            let error = NSError(domain: Bundle.main.bundleIdentifier ?? "",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Could not create url request",
                                    NSLocalizedFailureReasonErrorKey: "The provided baseUrl is not valid"])
            throw error
        }
        components.path = components.path.appending(path)
        components.queryItems = queryParams.compactMap { URLQueryItem(name: $0.key,
                                                                      value: $0.value) }
        
        if let url = components.url {
            var request  = URLRequest(url: url)
            request.httpMethod = "GET"
            headers.forEach { request.setValue($0.value,
                                               forHTTPHeaderField: $0.key) }
            return request
        } else {
            let error = NSError(domain: Bundle.main.bundleIdentifier ?? "",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Could not create url request",
                                    NSLocalizedFailureReasonErrorKey: "Url components are invalid"])
            throw error
        }
    }
}
