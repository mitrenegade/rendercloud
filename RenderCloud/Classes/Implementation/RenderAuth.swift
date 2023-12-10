//
//  RenderAuth.swift
//  RenderCloud
//
//  Created by Bobby Ren on 12/10/23.
//

import Foundation
import FirebaseAuth

protocol CloudAuthServiceDelegate: AnyObject {
    func userDidChange(user: User?)
}

protocol CloudAuthService {
    func signUp(username: String, password: String)
    func logIn(username: String, password: String)

    var delegate: CloudAuthServiceDelegate? { get }
}

final class RenderAuthService: CloudAuthService {

    private let apiService: CloudAPIService

    private var handler: AuthStateDidChangeListenerHandle?

    private var user: User?

    weak var delegate: CloudAuthServiceDelegate?

    private let auth = Auth.auth()

    // listener
    func listenToUserUpdates() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
            self?.delegate?.userDidChange(user: user)
        }
    }

    init(apiService: CloudAPIService = RenderAPIService(),
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

    func signUp(username: String, password: String) {
        auth.createUser(withEmail: username, password: password) { result, error in
            print("result \(result) error \(error)")
        }
    }

    func logIn(username: String, password: String) {
        auth.signIn(withEmail: username, password: password) { result, error in
            print("result \(result) error \(error)")
        }
    }
}
