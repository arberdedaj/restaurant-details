//
//  StorageMock.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import Foundation
@testable import RestaurantDetails

class StorageMock: StorageProtocol {

    /// Use keywords: "success" or "error" as a value
    private let behaviour: String

    init(behaviour: String) {
        self.behaviour = behaviour
    }
    
    func save<T>(_ object: T, for key: String) throws -> Bool where T : Encodable {
        if isBehaviourSuccess() {
            return true
        } else {
            let error = createError("Failed to persist the given object",
                                    reason: "Reason unknown",
                                    fromClass: type(of: self),
                                    code: 0)
            throw error
        }
    }
    
    func read<T>(_ object: T.Type, for key: String) throws -> T? where T : Decodable {
        if isBehaviourSuccess() {
            return [Restaurant(id: "1", name: nil, imageUrl: nil, location: nil, rating: nil, photos: nil)] as? T
        } else {
            let error = createError("Failed to load a value for the given key",
                                    reason: "Reason unknown",
                                    fromClass: type(of: self),
                                    code: 0)
            throw error
        }
    }
    
    func delete(for key: String) throws -> Bool {
        if isBehaviourSuccess() {
            return true
        } else {
            let error = createError("Failed to delete value for the given key",
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
