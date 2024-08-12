//
//  TestioVPNApp.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import SwiftUI

@main
struct TestioVPNApp: App {
    
    @StateObject var authorizationInteractor = DependencyContainer.shared.authorizationInteractor
    
    var body: some Scene {
        WindowGroup {
            switch authorizationInteractor.authorizationState {
            case .authorized:
                ServersListScreen()
            case .unauthorized:
                AuthorizationScreen()
            }
        }
    }
}

extension TestioVPNApp {
    static func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
