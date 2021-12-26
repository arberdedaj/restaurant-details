//
//  FileStorage.swift
//  RestaurantDetails
//
//  Created by Arber Dedaj on 21.12.21.
//

import Foundation

class FileStorage: StorageProtocol {

    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileManager: FileManager = .default,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder
    }

    func save<T>(_ object: T, for key: String) throws -> Bool where T: Encodable {
        guard let url = makeURL(forFileNamed: key) else {
            let error = createError("Could not save value: \(object) for key: \(key) into directory",
                                    reason: "Could not find a url in file manager with the given key",
                                    fromClass: type(of: self))
            throw error
        }
        let data = try encoder.encode(object)
        try data.write(to: url)
        return true
    }

    func read<T>(_ object: T.Type, for key: String) throws -> T? where T: Decodable {
        guard let url = makeURL(forFileNamed: key) else {
            let error = createError("Could not read from directory for key: \(key)",
                                    reason: "Could not find a url in file manager with the given key",
                                    fromClass: type(of: self))
            throw error
        }

        let data = try Data(contentsOf: url)
        let object = try decoder.decode(T.self, from: data)
        return object
    }

    func delete(for key: String) throws -> Bool {
        guard let url = makeURL(forFileNamed: key) else {
            let error = createError("Could not delete from directory for key: \(key)",
                                    reason: "Could not find a url in file manager with the given key",
                                    fromClass: type(of: self))
            throw error
        }
        try fileManager.removeItem(at: url)
        return true
    }

    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
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
