//
//  AuthorizationService.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import Foundation

protocol AuthorizationServicing {
    func login(userName: String, password: String) async throws -> AuthData
}

class AuthorizationService: AuthorizationServicing {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func login(userName: String, password: String) async throws -> AuthData {
        try await networkManager.request(AuthorizationRequest.getToken(userName: userName, password: password))
    }
}
