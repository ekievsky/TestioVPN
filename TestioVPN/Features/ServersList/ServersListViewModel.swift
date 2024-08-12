//
//  ServersListViewModel.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 09.08.2024.
//

import Foundation

@MainActor class ServersListViewModel: ObservableObject {
    
    enum SortingType {
        case alphabetical
        case byDistance
    }
    
    private let serverService: ServerServicing
    private let serverStorage: ServerStoring
    private let authorizationInteractor: any AuthorizationInteracting
    
    @Published private var items: [Server] = []
    @Published var presentingItems: [Server] = []
    @Published var isLoading: Bool = false
    @Published var isShowingError: Bool = false
    @Published var sortingType: SortingType?
    
    var isInitialLoading: Bool {
        isLoading && items.isEmpty && !isShowingError
    }
    
    init(
        serverService: ServerServicing = DependencyContainer.shared.serverService,
        serverStorage: ServerStoring = DependencyContainer.shared.serverStorage,
        authorizationInteractor: any AuthorizationInteracting = DependencyContainer.shared.authorizationInteractor
    ) {
        self.serverService = serverService
        self.serverStorage = serverStorage
        self.authorizationInteractor = authorizationInteractor
        
        $items
            .combineLatest($sortingType)
            .map { items, sorting in
                switch sorting {
                case .alphabetical:
                    return items.sorted(by: { $0.name < $1.name })
                case .byDistance:
                    return items.sorted(by: { $0.distance < $1.distance })
                case .none:
                    return items
                }
            }
            .assign(to: &$presentingItems)
    }
    
    func getServersList() async {
        defer {
            isLoading = false
        }
        isLoading = true
        do {
            let fetchedServers = try await serverService.getServersList()
            items = fetchedServers
            
            try await serverStorage.removeAllServers()
            await serverStorage.addServers(fetchedServers)
            isShowingError = false
        } catch {
            items = (try? await serverStorage.getAllServers()) ?? []
            isShowingError = true
        }
    }
    
    func logout() {
        authorizationInteractor.logout()
    }
    
    func updateSorting(_ sorting: SortingType?) {
        self.sortingType = sorting
    }
}
