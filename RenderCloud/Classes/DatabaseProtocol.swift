//
//  DatabaseProtocol.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import Foundation

public protocol DataSnapshot {
    func exists() -> Bool
    var value: [String: Any]? { get } // not sure if this is correct for DataSnapshot
}

public protocol DatabaseReference {
    func child(path: String) -> DatabaseReference
    func observeValue(completion: (DataSnapshot)->Void)
}
