//
//  RenderAPIService.swift
//  Balizinha
//
//  Created by Ren, Bobby on 2/25/18.
//  Copyright © 2018 Bobby Ren. All rights reserved.
//
import FirebaseCore
import FirebaseCoreInternal
import FirebaseAuth
import FirebaseInstallations
import FirebaseFunctions

public struct RenderAPIService: CloudAPIService {
    // variables for creating customer key
    private var urlSession: URLSession?
    private var dataTask: URLSessionDataTask?

    private let functions = Functions.functions()

    public init() {
        // no op
    }

    public func cloudFunction(functionName: String, completion: ((Any?, Error?) -> ())?) {
        cloudFunction(functionName: functionName, method: "POST", params: nil, completion: completion)
    }
    
    public func cloudFunction(functionName: String, method: String, params: [String: Any]?, completion: ((_ response: Any?, _ error: Error?) -> ())?) {
        functions.httpsCallable(functionName)
            .call(params) { result, error in
                completion?(result?.data, error)
            }
    }
}

// MARK: Cloud Database Service
extension RenderAPIService: CloudDatabaseService {
    public func connectedAccount(with userId: String) -> Reference? {
//        return reference(at: "stripeConnectedAccount")
        nil
    }
    
    public func reference(at child: String) -> Reference? {
        nil
//        return baseRef?.child(path: child)
    }
}
