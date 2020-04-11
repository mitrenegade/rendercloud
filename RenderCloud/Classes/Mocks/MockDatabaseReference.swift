//
//  MockDatabaseReference.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import UIKit

public class MockDataSnapshot: Snapshot {
    private var mockExists: Bool
    private var mockKey: String?
    private var mockValue: [String: Any]?
    private var mockRef: Reference?
    
    public init(exists: Bool, key: String? = "abc", value: [String: Any]?, ref: Reference? = nil) {
        mockExists = exists
        mockKey = key
        mockValue = value
        mockRef = ref
    }
    
    public func exists() -> Bool {
        return mockExists
    }
    
    public var key: String {
        return mockKey ?? "abc"
    }
    
    public var value: Any? {
        return mockValue
    }
    
    public var allChildren: [Snapshot]? {
        return [self]
    }
    
    public var reference: Reference? {
        return mockRef
    }
}

public class MockDatabaseReference: Reference {
    private var mockSnapshot: Snapshot
    
    public init(snapshot: Snapshot = MockDataSnapshot(exists: true, value: ["color": "blue"])) {
        mockSnapshot = snapshot
    }
    
    public func child(path: String) -> Reference {
        return self
    }
    
    public func observeValue(completion: (Snapshot) -> Void) {
        completion(mockSnapshot)
    }
    
    public func observeSingleValue(completion: @escaping (Snapshot) -> Void) {
        completion(mockSnapshot)
    }
    
    public func queryOrdered(by child: String) -> Query {
        return MockQuery(ref: self, snapshot: mockSnapshot)
    }
    
    public func updateChildValues(_ params: [AnyHashable : Any]) {
        return
    }
    
    public func removeValue() {
        return
    }
    
    public func removeAllObservers() {
        return
    }
}

public class MockQuery: Query {
    public func observeSingleValue(completion: @escaping (Snapshot) -> Void) {
        completion(mockSnapshot)
    }
    
    private var mockSnapshot: Snapshot
    private var mockReference: Reference
    public init(ref: Reference, snapshot: Snapshot) {
        mockReference = ref
        mockSnapshot = snapshot
    }
    
    public func queryEqual(to value: Any) -> Query {
        return MockQuery(ref: mockReference, snapshot: mockSnapshot)
    }
}
