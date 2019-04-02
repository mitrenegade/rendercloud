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
    var value: Any? { get }
}

public protocol Reference {
    // functions are slightly different than DatabaseReference
    func child(path: String) -> Reference
    func observeValue(completion: @escaping (Snapshot)->Void)
}
