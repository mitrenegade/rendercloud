//
//  CloudAPIProtocol.swift
//  Pods
//
//  Created by Bobby Ren on 2/24/19.
//

import Foundation

// interface into using cloud functions
public protocol CloudAPIService {
    func cloudFunction(functionName: String, completion: ((_ response: Any?, _ error: Error?) -> ())?)
    func cloudFunction(functionName: String, method: String, params: [String: Any]?, completion: ((_ response: Any?, _ error: Error?) -> ())?)
    func getUniqueId(completion: @escaping ((String?)->()))
    func uniqueId() -> String
    var baseUrl: URL? { get }
}

// interface into specific uses of the Database protocol
public protocol CloudDatabaseService {
    func connectedAccount(with userId: String) -> Reference?
}
