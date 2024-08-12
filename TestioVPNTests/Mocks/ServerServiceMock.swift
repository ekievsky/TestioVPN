//
//  ServerServiceMock.swift
//  TestioVPNTests
//
//  Created by Yevhen Kyivskyi on 11.08.2024.
//

import Foundation
@testable import TestioVPN

class ServerServiceMock: ServerServicing {
    
    var mockServersList: [Server] = [.buildMock(), .buildMock(), .buildMock()]
    var getServersListError: Error?
    
    func getServersList() async throws -> [Server] {
        try await Task.sleep(for: .seconds(1))
        if let getServersListError {
            throw getServersListError
        } else {   
            return mockServersList
        }
    }
}
