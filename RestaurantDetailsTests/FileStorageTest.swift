//
//  FileStorageTest.swift
//  RestaurantDetailsTests
//
//  Created by Arber Dedaj on 26.12.21.
//

import XCTest
@testable import RestaurantDetails

class FileStorageTest: XCTestCase {

    func testSaveObjectForKeySucceeds() {
        let fileManager = FileManagerMock(behaviour: "success")
        let fileStorage = FileStorage(fileManager: fileManager, encoder: JSONEncoderMock(), decoder: JSONDecoder())
        do {
            let isSaved = try fileStorage.save("example_string", for: "example_key")
            XCTAssertTrue(isSaved)
        } catch {
            XCTFail("It is not expected to fail in this case")
        }
    }

    func testSaveObjectForKeyFails() {
        let fileManager = FileManagerMock(behaviour: "error")
        let fileStorage = FileStorage(fileManager: fileManager, encoder: JSONEncoderMock(), decoder: JSONDecoder())
        do {
            _ = try fileStorage.save("example_string", for: "example_key")
            XCTFail("It is not expected to succeed")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testReadDataForKeySucceeds() {
        // Save data before reading
        testSaveObjectForKeySucceeds()

        let fileManager = FileManagerMock(behaviour: "success")
        let fileStorage = FileStorage(fileManager: fileManager, encoder: JSONEncoder(), decoder: JSONDecoderMock())
        do {
            let stringObject = try fileStorage.read(String.self, for: "example_key")
            XCTAssertNotNil(stringObject)
        } catch {
            XCTFail("It is not expected to fail in this case")
        }
    }

    func testReadDataForKeyFails() {
        let fileManager = FileManagerMock(behaviour: "error")
        let fileStorage = FileStorage(fileManager: fileManager, encoder: JSONEncoder(), decoder: JSONDecoderMock())
        do {
            _ = try fileStorage.read(String.self, for: "example_key")
            XCTFail("It is not expected to suceed in this case")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testDeleteForKeySucceeds() {
        // Save data beforing deleting
        testSaveObjectForKeySucceeds()

        let fileManager = FileManagerMock(behaviour: "success")
        let fileStorage = FileStorage(fileManager: fileManager, encoder: JSONEncoder(), decoder: JSONDecoder())
        do {
            let isDeleted = try fileStorage.delete(for: "example_key")
            XCTAssertTrue(isDeleted)
        } catch {
            XCTFail("It is not expected to fail in this case")
        }
    }

    func testDeleteForKeyFails() {
        let fileManager = FileManagerMock(behaviour: "error")
        let fileStorage = FileStorage(fileManager: fileManager, encoder: JSONEncoder(), decoder: JSONDecoder())
        do {
            _ = try fileStorage.delete(for: "example_key")
            XCTFail("It is not expected to fail in this case")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
