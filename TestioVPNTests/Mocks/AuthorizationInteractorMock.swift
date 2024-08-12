//
//  AuthorizationInteractorMock.swift
//  TestioVPNTests
//
//  Created by Yevhen Kyivskyi on 11.08.2024.
//

import Foundation
@testable import TestioVPN

class AuthorizationInteractorMock: AuthorizationInteracting {
    
    var state: AuthorizationState = .unauthorized
    
    var mockCheckAuthoState: AuthorizationState = .unauthorized
    var loginError: Error?

    func checkAuthState() {
        self.state = mockCheckAuthoState
    }
    
    func login(userName: String, password: String) async throws {
        try await Task.sleep(for: .seconds(1))
        if let loginError {
            throw loginError
        } else {
            self.state = .authorized
        }
    }
    
    func logout() {
        self.state = .unauthorized
    }
}
