//
//  ServersListViewModelTests.swift
//  TestioVPNTests
//
//  Created by Yevhen Kyivskyi on 11.08.2024.
//

import XCTest
@testable import TestioVPN

@MainActor final class ServersListViewModelTests: XCTestCase {
    
    var viewModel: ServersListViewModel!
    
    var serverService: ServerServiceMock!
    var serverStorageMock: ServerStorageMock!
    var authorizationInteractorMock: AuthorizationInteractorMock!
    
    var cancelBag = CancelBag()

    override func setUpWithError() throws {
        
        self.serverService = ServerServiceMock()
        self.serverStorageMock = ServerStorageMock()
        self.authorizationInteractorMock = AuthorizationInteractorMock()

        viewModel = ServersListViewModel(
            serverService: serverService,
            serverStorage: serverStorageMock,
            authorizationInteractor: authorizationInteractorMock
        )
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.serverService = nil
        self.serverStorageMock = nil
        self.authorizationInteractorMock = nil
        self.cancelBag.removeAll()
    }

    func testIsInitialLoading() async {
        viewModel.isLoading = true
        XCTAssertTrue(viewModel.isInitialLoading)
        
        viewModel.isLoading = false
        XCTAssertFalse(viewModel.isInitialLoading)
        
        viewModel.isLoading = true
        viewModel.isShowingError = true
        XCTAssertFalse(viewModel.isInitialLoading)
        
        viewModel.isLoading = true
        viewModel.isShowingError = false
        serverService.mockServersList = [.buildMock(), .buildMock()]
        await viewModel.getServersList()
        XCTAssertFalse(viewModel.isInitialLoading)
    }
    
    func testGetServerListFailure() async throws {
        let loadingStartedExpectation = expectation(description: "LoadingStarted")
        
        serverService.getServersListError = MockError.fail
        
        viewModel.$isLoading
            .filter { $0 }
            .sink { isLoading in
                loadingStartedExpectation.fulfill()
            }
            .store(in: &cancelBag)
        
        await viewModel.getServersList()
        
        await fulfillment(of: [loadingStartedExpectation], timeout: 5)
        
        XCTAssertTrue(viewModel.isShowingError)
        XCTAssertTrue(viewModel.presentingItems.isEmpty)
        let persistedItems = try await serverStorageMock.getAllServers()
        XCTAssertTrue(persistedItems.isEmpty)
    }
    
    func testGetServerListSuccess() async throws {
        let loadingStartedExpectation = expectation(description: "LoadingStarted")
        let mockServersList: [Server] = [.buildMock(), .buildMock(), .buildMock()]
        
        serverService.mockServersList = mockServersList
        
        viewModel.$isLoading
            .filter { $0 }
            .sink { isLoading in
                loadingStartedExpectation.fulfill()
            }
            .store(in: &cancelBag)
        
        await viewModel.getServersList()
        
        await fulfillment(of: [loadingStartedExpectation], timeout: 5)
        
        XCTAssertFalse(viewModel.isShowingError)
        XCTAssertEqual(viewModel.presentingItems, mockServersList)
        let persistedItems = try await serverStorageMock.getAllServers()
        XCTAssertTrue(!persistedItems.isEmpty)
    }
    
    func testLogout() {
        authorizationInteractorMock.state = .authorized
        
        viewModel.logout()
        
        XCTAssertEqual(authorizationInteractorMock.state, .unauthorized)
    }
    
    func testUpdateSorting() async {
        let loadingStartedExpectation = expectation(description: "LoadingStarted")
        let mockServersList: [Server] = [
            .buildMock(), .buildMock(), .buildMock(), .buildMock(), .buildMock(), .buildMock(), .buildMock(),
            .buildMock(), .buildMock(), .buildMock(), .buildMock(), .buildMock(), .buildMock(), .buildMock(),
            .buildMock(), .buildMock(), .buildMock(), .buildMock(), .buildMock(), .buildMock(), .buildMock()
        ]
        
        serverService.mockServersList = mockServersList
        
        viewModel.$isLoading
            .filter { $0 }
            .sink { isLoading in
                loadingStartedExpectation.fulfill()
            }
            .store(in: &cancelBag)
        
        await viewModel.getServersList()
        
        await fulfillment(of: [loadingStartedExpectation], timeout: 5)
        
        XCTAssertEqual(viewModel.presentingItems, mockServersList)
        
        viewModel.updateSorting(.alphabetical)
        XCTAssertEqual(viewModel.presentingItems, mockServersList.sorted(by: { $0.name < $1.name }))
        
        viewModel.updateSorting(.byDistance)
        XCTAssertEqual(viewModel.presentingItems, mockServersList.sorted(by: { $0.distance < $1.distance }))
        
        viewModel.updateSorting(nil)
        XCTAssertEqual(viewModel.presentingItems, mockServersList)
    }
}
