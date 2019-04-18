//
//  FirebaseExtensions.swift
//  RenderCloud_Example
//
//  Created by Bobby Ren on 4/18/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import RenderCloud
import FirebaseDatabase

// conformance of Firebase classes
extension DataSnapshot: Snapshot {
    public var allChildren: [Snapshot]? {
        return children.allObjects as? [Snapshot]
    }
    
    public var reference: Reference? {
        return ref
    }
    
}

extension DatabaseReference: Reference {
    public func observeSingleValue(completion: @escaping (Snapshot) -> Void) {
        observeSingleEvent(of: .value, with: completion)
    }
    
    public func queryOrdered(by child: String) -> Query {
        return queryOrdered(byChild: child)
    }
    
    public func observeValue(completion: @escaping (Snapshot) -> Void) {
        observe(.value, with: completion)
    }
    
    public func child(path: String) -> Reference {
        return child(path)
    }
}

extension DatabaseQuery: Query {
    public func queryEqual(to value: Any) -> Reference {
        return queryEqual(toValue: value) as! Reference
    }
}
