//
//  VPNTestTaskApp.swift
//  VPNTestTask
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import SwiftUI

@main
struct VPNTestTaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
