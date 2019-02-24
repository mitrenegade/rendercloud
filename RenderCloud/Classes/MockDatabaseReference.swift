//
//  MockDatabaseReference.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import UIKit

public class MockDataSnapshot: DataSnapshot {
    public func exists() -> Bool {
        return true
    }
    
    public func value() {
        return
    }
}

public class MockDatabaseReference: DatabaseReference {
    public func child(path: String) -> DatabaseReference {
        return self
    }
    
    public func observeValue(completion: (DataSnapshot) -> Void) {
        completion(MockDataSnapshot())
    }
}
