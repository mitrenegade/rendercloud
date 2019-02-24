//
//  FirebaseAPIService.swift
//  Balizinha
//
//  Created by Ren, Bobby on 2/25/18.
//  Copyright © 2018 Bobby Ren. All rights reserved.
//

import UIKit

fileprivate let API_VERSION: String = "1.1"

public class FirebaseAPIService: CloudAPIService {
    // variables for creating customer key
    private var urlSession: URLSession?
    private var dataTask: URLSessionDataTask?
    public static var baseURL: URL?
    
    public init() {
        urlSession = URLSession(configuration: .default)
    }
    
    public func uniqueId() -> String {
        // generates a unique id very similar to server's unique id, but doesn't make so many requests. matches API 1.1
        let secondsSince1970 = Int(Date().timeIntervalSince1970)
        let randomId = Int(arc4random_uniform(UInt32(899999))) + 100000
        return "\(secondsSince1970)-\(randomId)"
    }

    public func getUniqueId(completion: @escaping ((String?)->())) {
        cloudFunction(functionName: "getUniqueId", params: nil) { (result, error) in
            guard let result = result as? [String: String], let id = result["id"] else {
                completion(nil)
                return
            }
            completion(id)
        }
    }

    public func cloudFunction(functionName: String, method: String = "POST", params: [String: Any]? = nil, completion: ((_ response: Any?, _ error: Error?) -> ())?) {
        guard let url = FirebaseAPIService.baseURL?.appendingPathComponent(functionName) else {
            print("FirebaseAPIService: no baseURL set, did you forget to specify it?")
            completion?(nil, nil) // todo
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = method
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: Any] = params ?? [:]
        body["apiVersion"] = API_VERSION
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: body, options: [])
        } catch let error {
            print("FirebaseAPIService: cloudFunction could not serialize params: \(String(describing: params)) with error \(error)")
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
                    //print("FirebaseAPIService: urlSession completed with json \(json)")
                    if statusCode >= 300 {
                        completion?(nil, NSError(domain: "balizinha", code: statusCode, userInfo: json))
                    } else {
                        completion?(json, nil)
                    }
                } catch let error {
                    print("FirebaseAPIService \(url.absoluteString): JSON parsing resulted in code \(statusCode) error \(error)")
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

