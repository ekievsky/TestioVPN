//
//  ServerService.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 09.08.2024.
//

import Foundation

protocol ServerServicing {

    func getServersList() async throws -> [Server]
}

class ServerService: ServerServicing {

    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getServersList() async throws -> [Server] {
        try await networkManager.request(ServerRequest.getServersList, isAnonymous: false)
    }
}
