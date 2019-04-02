//
//  MockDatabaseReference.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import UIKit

public class MockDataSnapshot: Snapshot {
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

public class MockDatabaseReference: Reference {
    private var mockSnapshot: Snapshot

    public init(snapshot: Snapshot) {
        mockSnapshot = snapshot
    }

    public func child(path: String) -> Reference {
        return self
    }
    
    public func observeValue(completion: (Snapshot) -> Void) {
        completion(mockSnapshot)
    }
}
