//
//  DatabaseProtocol.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import Foundation
//import Firebase

public protocol DataSnapshot {
    func exists() -> Bool
    func value()
}

public protocol DatabaseReference {
    func child(path: String) -> DatabaseReference
    func observeValue(completion: (DataSnapshot)->Void)
}
