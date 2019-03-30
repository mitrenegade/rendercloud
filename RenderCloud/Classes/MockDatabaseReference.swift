//
//  MockDatabaseReference.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import UIKit

public class MockDataSnapshot: DataSnapshot {
    private var mockExists: Bool
    private var mockValue: [String: Any]?

    public init(exists: Bool, value: [String: Any]?) {
        mockExists = exists
        mockValue = value
    }
    
    public func exists() -> Bool {
        return mockExists
    }
    
    public var value: [String: Any]? {
        return mockValue
    }
}

public class MockDatabaseReference: DatabaseReference {
    private var mockSnapshot: DataSnapshot

    public init(snapshot: DataSnapshot) {
        mockSnapshot = snapshot
    }

    public func child(path: String) -> DatabaseReference {
        return self
    }
    
    public func observeValue(completion: (DataSnapshot) -> Void) {
        completion(mockSnapshot)
    }
}
