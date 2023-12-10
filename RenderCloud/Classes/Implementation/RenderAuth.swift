//
//  RenderAuth.swift
//  RenderCloud
//
//  Created by Bobby Ren on 12/10/23.
//

import Foundation
import FirebaseAuth

public final class RenderAuthService: CloudAuthService {

    private let apiService: CloudAPIService

    private var handler: AuthStateDidChangeListenerHandle?

    private var user: User?

    public weak var delegate: CloudAuthServiceDelegate?

    private let auth = Auth.auth()

    // listener
    func listenToUserUpdates() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
            self?.delegate?.userDidChange(user: user)
        }
    }

    public convenience init(delegate: CloudAuthServiceDelegate?) {
        self.init(apiService: RenderAPIService(), delegate: delegate)
    }

    internal init(apiService: CloudAPIService = RenderAPIService(),
         delegate: CloudAuthServiceDelegate? = nil) {
        self.apiService = apiService
        self.delegate = delegate

        listenToUserUpdates()
    }

    // Public functions

    // Async/Await

    /// Awaits signup and returns a User for synchronous signup processes
    /// Throws an NSError on failure
    public func signup(username: String, password: String) async throws -> User {
        do {
            let result = try await auth.createUser(withEmail: username, password: password)
            return result.user
        } catch {
            throw handleAuthError(error)
        }
    }

    /// Awaits login and returns a User for synchronous login processes
    /// Throws an NSError on failure
    public func login(username: String, password: String) async throws -> User {
        do {
            let result = try await auth.signIn(withEmail: username, password: password)
            return result.user
        } catch {
            throw handleAuthError(error)
        }
    }

    private func handleAuthError(_ error: Error) -> Error {
        print("error \(error)")
        let nsError = error as NSError
        switch nsError.code {
        case 17004:
            return RenderAuthError.loginInvalidCredentials
        case 17007:
            return RenderAuthError.signupUserExists
        case 17008:
            return RenderAuthError.invalidEmailFormat
        case 17026:
            return RenderAuthError.signupInvalidPasswordFormat
        default:
            // any other Error falls through
            return error
        }
    }

    /// Asynchronous logout. 
    /// Throws an NSError on failure
    /// Do we need an await logout?
    public func logout() throws {
        try auth.signOut()
    }

    // Closure
//    public func signup(username: String, password: String) {
//        auth.createUser(withEmail: username, password: password) { result, error in
//            print("result \(result) error \(error)")
//        }
//    }
//
//    public func login(username: String, password: String) {
//        auth.signIn(withEmail: username, password: password) { result, error in
//            print("result \(result) error \(error)")
//        }
//    }
}
