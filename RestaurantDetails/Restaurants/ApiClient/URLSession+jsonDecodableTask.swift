//
//  URLSession+jsonDecodableTask.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 21.12.21.
//

import Foundation

enum DataTaskError: Error {
    case noData
    case decoding
}

extension URLSession {
    func jsonDecodableTask<T: Decodable>(with url: URLRequest,
                                         decoder: JSONDecoder = JSONDecoder(),
                                         completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data, response != nil else {
                    completion(.failure(DataTaskError.noData))
                    return
                }

                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
