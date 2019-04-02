//
//  DemoViewController.swift
//  RenderCloud_Example
//
//  Created by Bobby Ren on 2/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RenderCloud
import Firebase

class DemoViewController: UIViewController {
    
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var labelToggle: UILabel!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var labelButton: UILabel!
    
    var apiService: CloudAPIService?
    var ref: Reference?
    var snapshot: Snapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        let baseUrl = TESTING ? FIREBASE_URL_DEV : FIREBASE_URL_PROD
        FirebaseAPIService.baseURL = URL(string: baseUrl)

        toggle.isOn = AIRPLANE_MODE
        labelToggle.text = AIRPLANE_MODE ? "AIRPLANE_MODE" : "CONNECTED"
        
        labelButton.text = "Click to update"
    }
    
    @IBAction func didClickButton(_ sender: Any?) {
        if AIRPLANE_MODE {
            loadAirplaneMode()
        } else {
            loadConnected()
        }
    }
    
    @IBAction func didToggle(_ sender: UISwitch) {
        AIRPLANE_MODE = sender.isOn
        labelToggle.text = AIRPLANE_MODE ? "AIRPLANE_MODE" : "CONNECTED"
    }
    
    func loadConnected() {
        apiService = FirebaseAPIService()
//        ref = apiService.child
        
        doLoad()
    }
    
    func loadAirplaneMode() {
        apiService = MockCloudAPIService(uniqueId: "123", results: ["data": "abc"])
        snapshot = MockDataSnapshot(exists: true, value: ["data": "123"])
        ref = MockDatabaseReference(snapshot: snapshot!)
        
        doLoad()
    }
    
    private func doLoad() {
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
                        self?.labelButton.text = "\(result)"
                    } else if let error = error as NSError? {
                        self?.labelButton.text = error.debugDescription
                    }
                }
            }
        }
    }
}
