//
//  cos_storeApp.swift
//  cos_store
//
//  Created by Vlad Sushko on 15/03/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import UserNotifications

@main
struct cos_storeApp: App {
    @State var showLaunchView: Bool = true
    @State var isAuth: Bool = false
    
    let authManager = AuthManager()
    
    init () {
        FirebaseApp.configure()
        Firestore.firestore()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ZStack {
                    AuthView(authManager: AuthManager(), userManager: UserManager(), isAuth: $isAuth)
                    if isAuth {
                        RootView(isAuth: $isAuth)
                    }
                }
                
                VStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .ignoresSafeArea(.all)
                            .transition(.move(edge: .leading))
                    }
                }
            }
            .onAppear {
                Task {
                    if (try? authManager.getAuthenticatedUser()) != nil {
                        isAuth = true
                    }
                }
            }
        }
    }
}






