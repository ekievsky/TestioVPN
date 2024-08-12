//
//  AuthorizationInteractor.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 09.08.2024.
//

import Foundation

enum AuthorizationState {
    case authorized
    case unauthorized
}

protocol AuthorizationInteracting: ObservableObject {

    func checkAuthState()
    func login(userName: String, password: String) async throws
    func logout()
}

class AuthorizationInteractor: AuthorizationInteracting {

    private let authorizationService: AuthorizationServicing
    private let secureStorage: SecureStoraging
    
    @Published var authorizationState: AuthorizationState = .unauthorized
    
    init(
        authorizationService: AuthorizationServicing,
        secureStorage: SecureStoraging
    ) {
        self.authorizationService = authorizationService
        self.secureStorage = secureStorage
        
        checkAuthState()
    }
    
    func checkAuthState() {
        if secureStorage.getString(for: "access-token") == nil {
            authorizationState = .unauthorized
        } else {
            authorizationState = .authorized
        }
    }
    
    @MainActor func login(userName: String, password: String) async throws {
        do {
            let data: AuthData = try await authorizationService.login(userName: userName, password: password)
            try secureStorage.setString(data.token, for: "access-token")
            authorizationState = .authorized
        } catch {
            throw NetworkError.invalidResponse
        }
    }
    
    @MainActor func logout() {
        try? SecureStorage().removeString(for: "access-token")
        authorizationState = .unauthorized
    }
}
