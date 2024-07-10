//
//  ProfileViewModel.swift
//  cos_store
//
//  Created by Vlad Sushko on 24/04/2024.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
   
    let authManager: AuthManager
    let userManager: UserManager
    
    @Published private(set) var user: DBUser? = nil
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    @Published var errorMessage = ""
    
    init(authManager: AuthManager, userManager: UserManager) {
        self.authManager = authManager
        self.userManager = userManager
    }
    
    func loadAuthUser() {
        self.authUser = try? authManager.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try authManager.signOut()
        self.user = nil
        self.authProviders = []
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try authManager.getAuthenticatedUser()
        self.user = try await userManager.getUser(userId: authDataResult.uid)
    }
    
    func loadAuthProviders() {
        if let providers = try? authManager.getProviders() {
            authProviders = providers
        }
    }
}
