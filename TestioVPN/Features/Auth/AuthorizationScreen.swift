//
//  AuthorizationScreen.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import SwiftUI

struct AuthorizationScreen: View {

    @StateObject var viewModel = AuthorizationViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            contentView
        }
        .background(Color.white)
        .onTapGesture {
            TestioVPNApp.resignFirstResponder()
        }
    }
}

private extension AuthorizationScreen {    
    var contentView: some View {
        VStack(spacing: 40) {
            Image.Testio.logo
            
            VStack(spacing: 20) {
                inputFieldsView
                loginButton
            }
            .padding(.horizontal, 32)
        }
    }
    
    @ViewBuilder var inputFieldsView: some View {
        TestioTextField(
            icon: .Testio.userIcon,
            placeholder: "Username",
            text: $viewModel.userName
        )
        TestioTextField(
            icon: .Testio.lockIcon,
            placeholder: "Password",
            isSecure: true,
            text: $viewModel.password
        )
    }
    
    var loginButton: some View {
        Button(
            action: {
                Task {
                    await viewModel.authorize()
                }
            },
            label: {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(width: 24, height: 24)
                        .tint(.white)
                } else {
                    Text("Log in")
                        .foregroundStyle(Color.white)
                        .font(Font.Testio.body)
                }
            }
        )
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(
            viewModel.isLoginButtonDisabled ? Color.Testio.accent.opacity(0.5) : Color.Testio.accent
        )
        .clipShape(RoundedRectangle(cornerSize: .init(width: 14, height: 14)))
        .disabled(viewModel.isLoginButtonDisabled)
        .alert("Verification failed", isPresented: $viewModel.isShowingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your username or password is incorrect.")
        }
    }
}

#Preview {
    AuthorizationScreen()
}
