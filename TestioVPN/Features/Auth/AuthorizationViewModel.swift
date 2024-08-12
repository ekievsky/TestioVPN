//
//  AuthorizationViewModel.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import Foundation
import SwiftUI

@MainActor class AuthorizationViewModel: ObservableObject {
    
    private let authorizationInteractor: any AuthorizationInteracting
    
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var isShowingError: Bool = false
    
    var isLoginButtonDisabled: Bool {
        userName.isEmpty || password.isEmpty
    }
    
    init(authorizationInteractor: any AuthorizationInteracting = DependencyContainer.shared.authorizationInteractor) {
        self.authorizationInteractor = authorizationInteractor
    }
    
    func authorize() async {
        defer {
            isLoading = false
        }
        isLoading = true
        do {
            try await authorizationInteractor.login(userName: userName, password: password)
        } catch {
            isShowingError = true
        }
    }
}
