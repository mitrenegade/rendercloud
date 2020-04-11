//
//  CloudDatabaseProtocol.swift
//  RenderCloud
//
//  Created by Bobby Ren on 4/10/20.
//

// interface into specific uses of the Database protocol
public protocol CloudDatabaseService {
    func connectedAccount(with userId: String) -> Reference?
    func reference(at child: String) -> Reference?
}
