//
//  StorageProtocol.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 21.12.21.
//

import Foundation

protocol StorageProtocol {

    /// Saves the object value for the specified key.
    ///
    /// - parameter object: The generic object value to store.
    /// - parameter key: The key with which to associate the object.
    func save<T: Encodable>(_ object: T, for key: String) throws -> Bool

    /// Reads the generic object value for the specified key.
    ///
    /// - parameter object: The generic object value to retrieve.
    /// - parameter key: The key to read the object from.
    func read<T: Decodable>(_ object: T.Type, for key: String) throws -> T?

    /// Deletes data at the specified key.
    ///
    /// - parameter key: The key to delete the data from.
    func delete(for key: String) throws -> Bool
}
