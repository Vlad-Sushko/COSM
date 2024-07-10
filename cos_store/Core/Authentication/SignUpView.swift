//
//  SignUpView.swift
//  cos_store
//
//  Created by Vlad Sushko on 24/04/2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SignUpView: View {
    
    @Binding var showAuthorizationView: Bool
    
    var body: some View {
        
        VStack(spacing: 10) {
            Button(action: {}, label: {
                HStack {
                    Image(systemName: "apple.logo")
                        .font(.title)
                    Text("Continue with Apple")
                    
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
            })
            
            Button(action: {}, label: {
                HStack {
                    Image(.googleLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .frame(maxWidth: 30)
                    Text("Continue with Google")
                    
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
            })
            
            NavigationLink {
                SignUpWithEmailView(authManager: AuthManager(), userManager: UserManager(), isAuth: $showAuthorizationView)
                    .padding(.horizontal, 12)
            } label: {
                HStack {
                    Image(systemName: "envelope")
                        .font(.title3)
                    Text("Sign up with email")
                    
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
            }
        }
        .bold()
    }
}

#Preview {
    NavigationStack {
        SignUpView(showAuthorizationView: .constant(true))
            .padding()
    }
}
