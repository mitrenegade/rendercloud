//
//  User.swift
//  RenderCloud
//
//  Created by Bobby Ren on 12/10/23.
//

import Foundation

/// A `User` interface that can be used to represent
/// a FirebaseUser or any other user
public protocol User {
    var id: String { get }
    var username: String { get }
}
