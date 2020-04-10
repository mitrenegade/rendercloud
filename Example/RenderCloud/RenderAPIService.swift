//
//  APIService.swift
//  RenderCloud_Example
//
//  Created by Bobby Ren on 4/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import RenderCloud

public class RenderAPIService: CloudAPIService {
    // variables for creating customer key
    private var urlSession: URLSession?
    private var dataTask: URLSessionDataTask?
    public var baseUrl: URL?
    
    // Database protocol
    private var baseRef: Reference?
    
    public init(baseUrl: String = "", baseRef: Reference?) {
        urlSession = URLSession(configuration: .default)
        self.baseUrl = URL(string: baseUrl)
        assert(self.baseUrl != nil, "RenderAPIService: no baseUrl set, did you forget to specify it?")
        self.baseRef = baseRef
    }
    
    public func uniqueId() -> String {
        // generates a unique id very similar to server's unique id, but doesn't make so many requests. matches API 1.1
        let secondsSince1970 = Int(Date().timeIntervalSince1970)
        let randomId = Int(arc4random_uniform(UInt32(899999))) + 100000
        return "\(secondsSince1970)-\(randomId)"
    }

    public func getUniqueId(completion: @escaping ((String?)->())) {
        cloudFunction(functionName: "getUniqueId") { (result, error) in
            guard let result = result as? [String: String], let id = result["id"] else {
                completion(nil)
                return
            }
            completion(id)
        }
    }

    public func cloudFunction(functionName: String, completion: ((Any?, Error?) -> ())?) {
        cloudFunction(functionName: functionName, method: "POST", params: nil, completion: completion)
    }
    
    public func cloudFunction(functionName: String, method: String, params: [String: Any]?, completion: ((_ response: Any?, _ error: Error?) -> ())?) {
        guard let url = baseUrl?.appendingPathComponent(functionName) else {
            completion?(nil, nil) // TODO
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = method
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: Any] = params ?? [:]
        body["apiVersion"] = 1.4
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: body, options: [])
        } catch let error {
            print("RenderAPIService: cloudFunction could not serialize params: \(String(describing: params)) with error \(error)")
        }
        
        dataTask = urlSession?.dataTask(with: request) { data, response, error in
            defer {
                self.dataTask = nil
            }
            let response: HTTPURLResponse? = response as? HTTPURLResponse
            let statusCode = response?.statusCode ?? 0
            
            if let usableData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as? [String: Any]
                    //print("RenderAPIService: urlSession completed with json \(json)")
                    if statusCode >= 300 {
                        completion?(nil, NSError(domain: "balizinha", code: statusCode, userInfo: json))
                    } else {
                        completion?(json, nil)
                    }
                } catch let error {
                    print("RenderAPIService \(url.absoluteString): JSON parsing resulted in code \(statusCode) error \(error)")
                    let dataString = String.init(data: usableData, encoding: .utf8)
                    print("StripeService: try reading data as string: \(String(describing: dataString))")
                    completion?(nil, error)
                }
            }
            else if let error = error {
                completion?(nil, error)
            }
            else {
                print("here")
            }
        }
        dataTask?.resume()
    }
}

extension RenderAPIService: CloudDatabaseService {
    static let connectRoot = "stripeConnectAccounts"
    public func connectedAccount(with userId: String) -> Reference? {
        return baseRef?.child(path: RenderAPIService.connectRoot).child(path: userId)
    }
}