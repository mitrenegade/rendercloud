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

    private var handler: AuthStateDidChangeListenerHandle

    private let user: User?

    weak var delegate: CloudAuthServiceDelegate?

    // listener
    func listenToUserUpdates() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
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

    func signUp(username: String, password: String) {
    }

    func logIn(username: String, password: String) {
        // no op
    }
}
