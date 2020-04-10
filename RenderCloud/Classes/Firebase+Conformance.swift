//
//  Firebase+Reference.swift
//  RenderCloud
//
//  Created by Bobby Ren on 4/9/20.
//
//  Dependency inversion
//  Makes Firebase's DatabaseReference conform to Reference, which is a RenderCloud requirement

import FirebaseDatabase

extension DataSnapshot: Snapshot {
    public var allChildren: [Snapshot]? {
        return children.allObjects as? [Snapshot]
    }
    
    public var reference: Reference? {
        return ref
    }
}

extension DatabaseReference: Reference {
    public func child(path: String) -> Reference {
        return self.child(path)
    }
    
    public func observeValue(completion: @escaping (Snapshot) -> Void) {
        observe(.value) { (snapshot) in
            completion(snapshot)
        }
    }
    
    public func queryOrdered(by child: String) -> Query {
        return queryOrdered(byChild: child)
    }
}

extension DatabaseQuery: Query {
    public func queryEqual(to value: Any) -> Query {
        return queryEqual(toValue: value)
    }
    
    public func observeSingleValue(completion: @escaping (Snapshot) -> Void) {
        return observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot)
        }
    }
    
    
}
