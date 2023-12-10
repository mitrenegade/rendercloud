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

    func signUp(username: String, password: String) async throws -> AuthDataResult {
        do {
            let result = try await auth.createUser(withEmail: username, password: password)
            return result
        } catch {
            print("error \(error)")
            throw error
        }
    }

    func logIn(username: String, password: String) async throws -> AuthDataResult {
        do {
            let result = try await auth.signIn(withEmail: username, password: password)
            return result
        } catch {
            print("error \(error)")
            throw error
        }
    }

    // Closure

    public func signUp(username: String, password: String) {
        auth.createUser(withEmail: username, password: password) { result, error in
            print("result \(result) error \(error)")
        }
    }

    public func logIn(username: String, password: String) {
        auth.signIn(withEmail: username, password: password) { result, error in
            print("result \(result) error \(error)")
        }
    }
}
