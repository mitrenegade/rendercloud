//
//  CloudAuthProtocol.swift
//  RenderCloud
//
//  Created by Bobby Ren on 12/10/23.
//

import Foundation

public protocol CloudAuthServiceDelegate: AnyObject {
    func userDidChange(user: User?)
}

public protocol CloudAuthService {
    func signUp(username: String, password: String)
    func logIn(username: String, password: String)

    var delegate: CloudAuthServiceDelegate? { get }
}
