//
//  DemoViewController.swift
//  RenderCloud_Example
//
//  Created by Bobby Ren on 2/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RenderCloud
import FirebaseAuth
import FirebaseDatabase

class DemoViewController: UIViewController {
    
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var labelToggle: UILabel!
    
    @IBOutlet weak var buttonCloud: UIButton!
    @IBOutlet weak var labelCloud: UILabel!

    @IBOutlet weak var buttonRef: UIButton!
    @IBOutlet weak var labelRef: UILabel!

    var apiService: (CloudAPIService & CloudDatabaseService)?

    override func viewDidLoad() {
        super.viewDidLoad()

        toggle.isOn = AIRPLANE_MODE
        labelToggle.text = AIRPLANE_MODE ? "AIRPLANE_MODE" : "CONNECTED"
        
        labelCloud.text = "Click to load from cloud"
        labelCloud.text = "Click to load from database"
    }
    
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
            let baseUrl = TESTING ? FIREBASE_URL_DEV : FIREBASE_URL_PROD
            let baseRef = Database.database().reference()
            apiService = RenderAPIService(baseUrl: baseUrl, baseRef: baseRef)
        }

        // make protocol request
        if sender == buttonCloud {
            doLoadCloud()
        } else {
            doLoadRef()
        }
    }
    
    private func doLoadCloud() {
        // CloudAPIService
        apiService?.getUniqueId { [weak self] (id) in
            guard let id = id else {
                assertionFailure("ID generation failed!")
                return
            }
            print("UniqueId generated from cloud: \(id)")
            self?.apiService?.cloudFunction(functionName: "sampleCloudFunction", method: "POST", params: ["uid": id, "email": "test@gmail.com"]) { [weak self] (result, error) in
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
}
