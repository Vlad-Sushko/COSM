//
//  AuthViewModel.swift
//  cos_store
//
//  Created by Vlad Sushko on 20/04/2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name = ""
    
    let authManager: AuthManager
    let userManager: UserManager
    
    init(authManager: AuthManager, userManager: UserManager) {
        self.authManager = authManager
        self.userManager = userManager
    }
    
    func registerUser(name: String?) async throws {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }
        let authDataResult = try await authManager.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult, name: name)
        try await userManager.createNewUser(user: user)
        
        try await authManager.loginUser(email: email, password: password)
        clearInputFields()
    }
    
    func loginUser() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }
        try await authManager.loginUser(email: email, password: password)
    }
    
    func clearInputFields() {
        self.email = ""
        self.password = ""
        self.name = ""
    }
    
    // TODO: Create UI
    func resetPassword() async throws {
        try await authManager.resetPassword(email: email)
    }
    // TODO: Create UI
    func updateEmail(email: String) async throws {
        try await authManager.updateEmail(email: email)
    }
    
    // TODO: Create UI
    func updatePassword(password: String) async throws {
        try await authManager.updatePassword(password: password)
    }
    
    // APPLE SIGN IN
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await self.authManager.signInWithApple(tokens: tokens)
        try await userManager.checkRegistrationInDatabase(authManager: authManager)
    }
    
    // GOOGLE SIGN IN
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await authManager.signInWithGoogle(tokens: tokens)
        try await userManager.checkRegistrationInDatabase(authManager: authManager)
    }
    
    // ANONYMOUS SIGN IN
    func signInAnonymous() async throws {
        try await authManager.signInAnonymous()
    }
}





