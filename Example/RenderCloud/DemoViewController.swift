//
//  DemoViewController.swift
//  RenderCloud_Example
//
//  Created by Bobby Ren on 2/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RenderCloud
import FirebaseDatabase

class DemoViewController: UIViewController {
    
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var labelToggle: UILabel!
    
    @IBOutlet weak var buttonCloud: UIButton!
    @IBOutlet weak var labelCloud: UILabel!

    @IBOutlet weak var buttonRef: UIButton!
    @IBOutlet weak var labelRef: UILabel!

    // Login view
    @IBOutlet weak var labelLoginInfo: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonSignup: UIButton!
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!

    var apiService: (CloudAPIService & CloudDatabaseService)?

    var authService: CloudAuthService?

    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        toggle.isOn = AIRPLANE_MODE
        labelToggle.text = AIRPLANE_MODE ? "AIRPLANE_MODE" : "CONNECTED"
        
        labelCloud.text = "Click to call a cloud function"
        labelCloud.text = "Click to load from database"

        authService = RenderAuthService(delegate: self)
    }
    
    // MARK: - IBActions

    @IBAction func didToggle(_ sender: UISwitch) {
        AIRPLANE_MODE = sender.isOn
        labelToggle.text = AIRPLANE_MODE ? "AIRPLANE_MODE" : "CONNECTED"
    }
    
    @IBAction func didClickButton(_ sender: UIButton) {
        // setup data
        if AIRPLANE_MODE {
            apiService = MockCloudAPIService(uniqueId: "123", results: ["data": "abc"])

            let snapshot = MockDataSnapshot(exists: true, value: ["data": "123"])
        } else {
            apiService = RenderAPIService()
        }

        // make protocol request
        if sender == buttonCloud {
            doCloudFunction()
        } else {
            doLoadRef()
        }
    }

    @IBAction func didClickLogin(_ sender: UIButton) {
        // login/logout
        guard user == nil else {
            // logout
            doLogout()
            return
        }

        doLogin()
    }

    @IBAction func didClickSignup(_ sender: UIButton) {
        doSignup()
    }

    // MARK: - Private Functions

    private func doCloudFunction() {
        // CloudAPIService
        apiService?.cloudFunction(functionName: "helloWorld") { [weak self] (result, error) in
            print("Result \(String(describing: result)) error \(String(describing: error))")
            DispatchQueue.main.async { [weak self] in
                if let result = result {
                    self?.labelCloud.text = "\(result)"
                } else if let error = error as NSError? {
                    self?.labelCloud.text = error.debugDescription
                }
            }
        }
    }
    
    private func doLoadRef() {
        apiService?.reference(at: "about")?.observeValue(completion: { [weak self] (snapshot) in
            guard snapshot.exists() else {
                self?.labelRef.text = "snapshot doesn't exist"
                return
            }
            print("Snapshot \(snapshot.value!)")
            self?.labelRef.text = "\(snapshot.value!)"
        })
    }

    // MARK: - Auth
    private func authMessage(_ string: String) {
        labelLoginInfo.text = string
    }

    private func doLogout() {
        do {
            try authService?.logout()
        } catch {
            print("Logout error")
        }
    }

    /// Demo login function using email and password
    /// To test signup failure for an existing user, call doSignup on button click
    private func doLogin() {
        guard let username = inputUsername.text, !username.isEmpty else {
            authMessage("Invalid username!")
            return
        }
        guard let password = inputPassword.text, !password.isEmpty else {
            authMessage("Invalid password!")
            return
        }

        Task {
            do {
                _ = try await authService?.login(username: username, password: password)
            } catch let error as RenderAuthError {
                authMessage("Auth error: \(error)")
            } catch {
                authMessage("Login error: \(error.localizedDescription)")
            }
        }
    }

    /// Demo signup function using email and password
    /// This happens if login fails
    private func doSignup() {
        guard let username = inputUsername.text, !username.isEmpty else {
            authMessage("Invalid username!")
            return
        }
        guard let password = inputPassword.text, !password.isEmpty else {
            authMessage("Invalid password!")
            return
        }

        Task {
            do {
                _ = try await authService?.signup(username: username, password: password)
            } catch let error as RenderAuthError {
                authMessage("Auth error: \(error)")
            } catch {
                authMessage("Signup error: \(error.localizedDescription)")
            }
        }
    }
}

extension DemoViewController: CloudAuthServiceDelegate {
    func userDidChange(user: RenderCloud.User?) {
        if let user {
            labelLoginInfo.text = "Logged in as \(user.username)"
            buttonLogin.setTitle("Log out", for: .normal)
            inputUsername.text = nil
            inputPassword.text = nil

            buttonSignup.isEnabled = false
        } else {
            labelLoginInfo.text = "Logged out"
            buttonLogin.setTitle("Log in", for: .normal)
            inputUsername.text = self.user?.username

            buttonSignup.isEnabled = true
        }
        print("Setting user to \(user?.username)")
        self.user = user
    }
}
