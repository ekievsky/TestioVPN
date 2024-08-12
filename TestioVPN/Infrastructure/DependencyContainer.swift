//
//  Container.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import Foundation
import SwiftUI

class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    private init() {
        serverConfig = ServerConfig(domain: "https://playground.tesonet.lt")
    }
    
    // MARK: Infrastructure
    let serverConfig: ServerConfig
    
    lazy var requestConfigurator = RequestConfigurator()
    lazy var networkManager = NetworkManager(requestConfigurator: requestConfigurator)
    let persistencyManager = PersistencyManager()
    
    // MARK: Utilities
    var securedStorage: SecureStoraging {
        SecureStorage()
    }
    
    lazy var authorizationInteractor = AuthorizationInteractor(authorizationService: authorizationService, secureStorage: securedStorage)
    
    // MARK: Storage
    var serverStorage: ServerStoring {
        ServerStorage()
    }
        
    // MARK: Services
    var authorizationService: AuthorizationServicing {
        AuthorizationService(networkManager: networkManager)
    }
    
    var serverService: ServerServicing {
        ServerService(networkManager: networkManager)
    }
    
}
