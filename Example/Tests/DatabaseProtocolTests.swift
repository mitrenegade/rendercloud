//
//  DatabaseProtocolTests.swift
//  RenderCloud_Tests
//
//  Created by Bobby Ren on 2/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import RenderCloud

class DatabaseProtocolTests: XCTestCase {
    var firRef: Reference!
    var snapshot: Snapshot!
    
    override func setUp() {
        snapshot = MockDataSnapshot(exists: true, value: ["data": "123"])
        firRef = MockDatabaseReference(snapshot: snapshot)
    }

    func testSnapshotExists() {
        XCTAssertTrue(snapshot.exists())
    }

    func testSnapshotValue() {
        XCTAssertNotNil(snapshot.value != nil)
        XCTAssertEqual(snapshot.value!["data"] as? String, "123")
    }
}
