//
//  DatabaseProtocol.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import Foundation
import FirebaseCore

public protocol Snapshot {
    func exists() -> Bool
    var value: [String: Any]? { get } // not sure if this is correct for DataSnapshot
}

public protocol Reference {
    func child(path: String) -> Reference
    func observeValue(completion: (Snapshot)->Void)
}
