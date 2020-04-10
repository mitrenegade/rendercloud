//
//  MockCloudAPIService.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import UIKit

public class MockCloudAPIService: NSObject, CloudAPIService {
    public var baseUrl: URL?
    
    private var mockUniqueId: String?
    private var mockResults: [String: Any]?
    
    public init(uniqueId: String, results: [String: Any]?) {
        mockUniqueId = uniqueId
        mockResults = results
        baseUrl = nil
        super.init()
    }

    public func cloudFunction(functionName: String, completion: ((Any?, Error?) -> ())?) {
        cloudFunction(functionName: functionName, method: "POST", params: nil, completion: completion)
    }
    
    public func cloudFunction(functionName: String, method: String, params: [String : Any]?, completion: ((Any?, Error?) -> ())?) {
        var results: [String: Any] = mockResults ?? [:]

        // the mock class reflects method and params
        results["method"] = method
        results["params"] = params
        completion?(results, nil)
    }
    
    public func getUniqueId(completion: @escaping ((String?) -> ())) {
        completion(mockUniqueId)
    }
    
    public func uniqueId() -> String {
        return mockUniqueId ?? "123"
    }
}
