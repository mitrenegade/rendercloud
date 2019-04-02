//
//  DemoViewController.swift
//  RenderCloud_Example
//
//  Created by Bobby Ren on 2/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RenderCloud

class DemoViewController: UIViewController {
    
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var labelToggle: UILabel!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var labelButton: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let baseUrl = TESTING ? FIREBASE_URL_DEV : FIREBASE_URL_PROD
        FirebaseAPIService.baseURL = URL(string: baseUrl)
        
        guard !AIRPLANE_MODE else { return }

        // CloudAPIService
        let service = FirebaseAPIService()
        service.getUniqueId { (id) in
            guard let id = id else {
                assertionFailure("ID generation failed!")
                return
            }
            print("UniqueId generated from cloud: \(id)")
            service.cloudFunction(functionName: "sampleCloudFunction", method: "POST", params: ["uid": id, "email": "test@gmail.com"]) { (result, error) in
                print("Result \(String(describing: result)) error \(String(describing: error))")
            }
        }
    }
    
    @IBAction func didClickButton(_ sender: Any?) {
        
    }
    
    @IBAction func didToggle(_ sender: UISwitch?) {
        
    }
}
