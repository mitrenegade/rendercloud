//
//  MockCloudAPIService.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import UIKit

public class MockCloudAPIService: NSObject, CloudAPIService {
    public func cloudFunction(functionName: String, completion: ((Any?, Error?) -> ())?) {
        cloudFunction(functionName: functionName, method: "POST", params: nil, completion: completion)
    }
    
    public func cloudFunction(functionName: String, method: String, params: [String : Any]?, completion: ((Any?, Error?) -> ())?) {
        completion?(["result": "success"], nil)
    }
    
    public func getUniqueId(completion: @escaping ((String?) -> ())) {
        completion("123")
    }
    
    public func uniqueId() -> String {
        return "123"
    }
    

}
