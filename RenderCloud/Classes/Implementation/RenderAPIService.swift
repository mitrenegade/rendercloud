//
//  RenderAPIService.swift
//  Balizinha
//
//  Created by Ren, Bobby on 2/25/18.
//  Copyright © 2018 Bobby Ren. All rights reserved.
//

fileprivate let API_VERSION: String = "1.1"

public class RenderAPIService: CloudAPIService {
    // variables for creating customer key
    private var urlSession: URLSession?
    private var dataTask: URLSessionDataTask?
    public var baseUrl: URL?
    
    // Database protocol
    var baseRef: Reference?
    
    public init(baseUrl: String?, baseRef: Reference?) {
        urlSession = URLSession(configuration: .default)
        if let url = baseUrl {
            self.baseUrl = URL(string: url)
        }
        assert(self.baseUrl != nil, "RenderAPIService: no baseUrl set, did you forget to specify it?")
        self.baseRef = baseRef
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
        body["apiVersion"] = API_VERSION
        
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

// MARK: Cloud Database Service
extension RenderAPIService: CloudDatabaseService {
    public func connectedAccount(with userId: String) -> Reference? {
        return reference(at: "stripeConnectedAccount")
    }
    
    public func reference(at child: String) -> Reference? {
        return baseRef?.child(path: child)
    }
}
