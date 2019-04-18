//
//  DatabaseProtocol.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import Foundation

public protocol Snapshot {
    // currently matches function signature of DataSnapshot
    func exists() -> Bool
    var key: String { get }
    var value: Any? { get }
    var allChildren: [Snapshot]? { get }
    var reference: Reference? { get }
}

public protocol Reference {
    // functions are slightly different than DatabaseReference
    func child(path: String) -> Reference
    func observeSingleValue(completion: @escaping (Snapshot)->Void)
    func observeValue(completion: @escaping (Snapshot)->Void)
    
    func queryOrdered(by child: String) -> Query
    func updateChildValues(_ params: [AnyHashable: Any])
    func removeValue()
    
    func removeAllObservers()
}

public protocol Query {
    func queryEqual(to value: Any) -> Reference
}
