//
//  FileManagerMock.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import Foundation

class FileManagerMock: FileManager {

    private let behaviour: String

    init(behaviour: String) {
        self.behaviour = behaviour
    }

    override func urls(for directory: FileManager.SearchPathDirectory,
                       in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        if behaviour == "success" {
            return super.urls(for: directory, in: domainMask)
        } else {
            return []
        }
    }
}
