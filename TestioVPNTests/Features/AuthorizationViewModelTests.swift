//
//  AuthorizationViewModelTests.swift
//  TestioVPNTests
//
//  Created by Yevhen Kyivskyi on 11.08.2024.
//

import XCTest
@testable import TestioVPN

@MainActor final class AuthorizationViewModelTests: XCTestCase {
    
    var viewModel: AuthorizationViewModel!
    
    var authorizationInteractorMock: AuthorizationInteractorMock!
    
    var cancelBag = CancelBag()

    override func setUpWithError() throws {
        
        self.authorizationInteractorMock = AuthorizationInteractorMock()
        
        viewModel = AuthorizationViewModel(authorizationInteractor: authorizationInteractorMock)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.authorizationInteractorMock = nil
        self.cancelBag.removeAll()
    }

    func testIsLoadingButtonDisabled() {
        XCTAssertTrue(viewModel.isLoginButtonDisabled)
        
        viewModel.userName = "username"
        
        XCTAssertTrue(viewModel.isLoginButtonDisabled)
        
        viewModel.password = "password"
        
        XCTAssertFalse(viewModel.isLoginButtonDisabled)
    }
    
    func testAuthorizationFail() async {
        XCTAssertFalse(viewModel.isShowingError)
        
        let loadingStartedExpectation = expectation(description: "LoadingStarted")
        viewModel.userName = "username"
        viewModel.password = "password"
        
        authorizationInteractorMock.loginError = MockError.fail
        
        viewModel.$isLoading
            .filter { $0 }
            .sink { isLoading in
                loadingStartedExpectation.fulfill()
            }
            .store(in: &cancelBag)
        
        await viewModel.authorize()
        
        await fulfillment(of: [loadingStartedExpectation], timeout: 5)
        
        XCTAssertTrue(viewModel.isShowingError)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testAuthorizationSuccess() async {
        XCTAssertFalse(viewModel.isShowingError)
        
        let loadingStartedExpectation = expectation(description: "LoadingStarted")
        viewModel.userName = "username"
        viewModel.password = "password"
        
        viewModel.$isLoading
            .filter { $0 }
            .sink { isLoading in
                loadingStartedExpectation.fulfill()
            }
            .store(in: &cancelBag)
        
        await viewModel.authorize()
        await fulfillment(of: [loadingStartedExpectation], timeout: 5)
        
        XCTAssertFalse(viewModel.isShowingError)
        XCTAssertFalse(viewModel.isLoading)
    }

}
