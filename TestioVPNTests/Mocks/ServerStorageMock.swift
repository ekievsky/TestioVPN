//
//  ServerStorageMock.swift
//  TestioVPNTests
//
//  Created by Yevhen Kyivskyi on 11.08.2024.
//

import Foundation
@testable import TestioVPN

class ServerStorageMock: ServerStoring {
    
    private var servers: [Server] = []
    
    func addServer(_ server: Server) {
        servers.append(server)
    }
    
    func getAllServers() async throws -> [Server] {
        servers
    }
    
    func addServers(_ servers: [Server]) async {
        self.servers.append(contentsOf: servers)
    }
    
    func removeAllServers() async throws {
        servers.removeAll()
    }
}
