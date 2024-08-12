//
//  ServerStorage.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import CoreData

protocol ServerStoring {

    func addServer(_ server: Server)
    func getAllServers() async throws -> [Server]
    func addServers(_ servers: [Server]) async
    func removeAllServers() async throws
}

class ServerStorage: ServerStoring {

    private let persistencyManager: PersistencyManager

    init(persistencyManager: PersistencyManager = DependencyContainer.shared.persistencyManager) {
        self.persistencyManager = persistencyManager
    }

    func addServer(_ server: Server) {
        let serverEntity = ServerEntity(context: persistencyManager.context)
        serverEntity.name = server.name
        serverEntity.distance = Int32(server.distance)

        do {
            try persistencyManager.context.save()
        } catch {
            assertionFailure("Core Data: Failed to save servers: \(error)")
        }
    }

    func getAllServers() async throws -> [Server] {
        let fetchRequest: NSFetchRequest<ServerEntity> = ServerEntity.fetchRequest()
        let backgroundContext = persistencyManager.backgroundContext
        
        return try await backgroundContext.perform {
            let serverEntities = try backgroundContext.fetch(fetchRequest)
            return serverEntities.compactMap {
                Server(name: $0.name ?? "", distance: Int($0.distance))
            }
        }
    }
    
    func addServers(_ servers: [Server]) async {
        let backgroundContext = persistencyManager.backgroundContext
        
        await backgroundContext.perform {
            servers.forEach { server in
                let serverEntity = ServerEntity(context: backgroundContext)
                serverEntity.name = server.name
                serverEntity.distance = Int32(server.distance)
            }
            
            do {
                try backgroundContext.save()
            } catch {
                assertionFailure("Core Data: Failed to save servers: \(error)")
            }
        }
    }
    
    func removeAllServers() async throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ServerEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let backgroundContext = persistencyManager.backgroundContext
        
        try await backgroundContext.perform {
            try backgroundContext.execute(deleteRequest)
            try backgroundContext.save()
        }
    }
}
