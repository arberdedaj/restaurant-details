//
//  FavoritesPersistenceMock.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import Foundation
@testable import RestaurantDetails

class FavoritesPersistenceMock: FavoritesPersistenceProtocol {

    /// Use keywords: "success" or "error" as a value
    private let behaviour: String

    init(behaviour: String) {
        self.behaviour = behaviour
    }

    func saveFavorites(key: String, restaurants: [Restaurant]) throws -> Bool {
        if isBehaviourSuccess() {
            return true
        } else {
            let error = createError("Failed to persist favorites",
                                    reason: "Reason unknown",
                                    fromClass: type(of: self),
                                    code: 0)
            throw error
        }
    }
    
    func loadFavorites(key: String) throws -> [Restaurant]? {
        if isBehaviourSuccess() {
            return RestaurantsMock.restaurants
        } else {
            let error = createError("Failed to load favorites",
                                    reason: "Reason unknown",
                                    fromClass: type(of: self),
                                    code: 0)
            throw error
        }
    }
    
    func deleteFavorites(key: String) throws -> Bool {
        if isBehaviourSuccess() {
            return true
        } else {
            let error = createError("Failed to delete favorites",
                                    reason: "Reason unknown",
                                    fromClass: type(of: self),
                                    code: 0)
            throw error
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
