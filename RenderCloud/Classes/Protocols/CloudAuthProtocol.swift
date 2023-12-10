//
//  CloudAuthProtocol.swift
//  RenderCloud
//
//  Created by Bobby Ren on 12/10/23.
//

import Foundation

public enum RenderAuthError: Error {
    case loginInvalidCredentials
    case signupUserExists
    case invalidEmailFormat
    case signupInvalidPasswordFormat
}

public protocol CloudAuthServiceDelegate: AnyObject {
    func userDidChange(user: RenderCloud.User?)
}

public protocol CloudAuthService {
    /// Awaits completion of signup and returns a User
    /// Throws an NSError on failure
    func signup(username: String, password: String) async throws -> RenderCloud.User

    /// Awaits completion of login and returns a User
    /// Throws an NSError on failure
    func login(username: String, password: String) async throws -> RenderCloud.User

    /// Awaits completion of logout
    /// Throws an NSError on failure
    func logout() throws

    var delegate: CloudAuthServiceDelegate? { get }
}
