//
//  AuthView.swift
//  cos_store
//
//  Created by Vlad Sushko on 20/04/2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import _AuthenticationServices_SwiftUI

struct AuthView: View {
    
    @Binding var isAuth: Bool
    
    @StateObject private var vm: AuthViewModel
    
    @State private var haveAccount: Bool = false
    @State private var showResetPasswordSection: Bool = false
    @State private var errorMessage: String? = nil
    
    @Namespace private var namespace
    
    init(authManager: AuthManager, userManager: UserManager, isAuth: Binding<Bool>) {
        self._vm = StateObject(wrappedValue: AuthViewModel(authManager: authManager, userManager: userManager))
        self._isAuth = isAuth
    }
    
    var body: some View {
        ZStack {
                NavigationStack {
                    VStack(spacing: 14) {
                        logo
                        
                        authorizationMethodSelector
                        
                        Divider()
                        
                        if !haveAccount {
                            VStack {
                                signInWithAppleButton
                                
                                signUpWithEmailButton
                                
                                googleSignInButton
                            
                                signInAsAGuest
                                    .padding(.top, 12)
                            }
                            .transition(.push(from: .leading))
                        } else {
                            VStack {
                                textFieldsSections
                                
                                authorizationButton
                                
                                forgotPasswordButton
                            }
                            .frame(height: 260)
                            .transition(.push(from: .trailing))
                        }
                    }
                    .tint(.primary)
                    .padding()
                    .background(.whiteBlackBG.shadow(.drop(radius: 8)))

                }
                .alert(errorMessage ?? "Error", isPresented: Binding(value: $errorMessage)) {
                    Button(action: {}, label: {
                        Text("OK")
                    })
                }
                .fullScreenCover(isPresented: $showResetPasswordSection) {
                    ResetPasswordView(authManager: AuthManager(), userManager: UserManager())
                        .padding(.horizontal)
                }
            }
        
    }
}

extension AuthView {
    private var logo: some View {
        Image(.logoCOSM)
            .resizable()
            .scaledToFit()
            .frame(width: 140, height: 100)
    }
    
    private var authorizationMethodSelector: some View {
        ZStack {
            HStack() {
                Button(action: {
                    withAnimation(.spring) {
                        haveAccount = false
                    }
                }, label: {
                    ZStack {
                        if !haveAccount {
                            Rectangle()
                                .fill(.grayBG)
                                .clipShape(.rect(topLeadingRadius: 10, bottomLeadingRadius: 10))
                                .frame(height: 50)
                                .matchedGeometryEffect(id: "authorization_method", in: namespace)
                        }
                        Text("SIGN UP")
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                })
                
                Button(action: {
                    withAnimation(.spring) {
                        haveAccount = true
                    }
                }, label: {
                    ZStack {
                        if haveAccount {
                            Rectangle()
                                .fill(.grayBG)
                                .clipShape(.rect(bottomTrailingRadius: 10, topTrailingRadius: 10))
                                .frame(height: 50)
                                .matchedGeometryEffect(id: "authorization_method", in: namespace)
                        }
                        Text("LOGIN")
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                    }
                })
            }
        }
    }
    private var textFieldsSections: some View {
        VStack {
            TextField("Email..", text: $vm.email)
                .textInputAutocapitalization(.never)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
            
            SecureField("Password..", text: $vm.password)
                .textContentType(.password)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    private var authorizationButton: some View {
        if haveAccount {
            Button(action: {
                Task {
                    do {
                        try await vm.loginUser()
                        isAuth = true
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }, label: {
                Text("Log in")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.grayBG)
                    .clipShape(.rect(cornerRadius: 10))
            })
        } else {
            Button(action: {
                Task {
                    do {
                        try await vm.registerUser(name: vm.name)
                        isAuth = true
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }, label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.grayBG)
                    .clipShape(.rect(cornerRadius: 10))
            })
        }
    }
    
    private var forgotPasswordButton: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation(.spring) {
                    showResetPasswordSection.toggle()
                }
            }, label: {
                Text("Forgot password?")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
                    .padding(.vertical)
            })
        }
    }
    
    private var signInWithAppleButton: some View {
        Button(action: {
            Task {
                do {
                    try await vm.signInApple()
                    isAuth = true
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }, label: {
            SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                .allowsHitTesting(false)
        })
        .frame(height: 55)
        
    }
    
    private var signUpWithEmailButton: some View {
        NavigationLink {
            SignUpWithEmailView(authManager: AuthManager(), userManager: UserManager(), isAuth: $isAuth)
                .padding(.horizontal, 12)
        } label: {
            HStack {
                Image(systemName: "envelope")
                    .font(.title3)
                Text("Sign up with email")
                    .font(.title3)
                
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.buttonBackground)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    private var signInAsAGuest: some View {
        Button(action: {
            Task {
                do {
                    try await vm.signInAnonymous()
                    isAuth = true
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }, label: {
            HStack {
                Image(systemName: "eyes")
                    .font(.title3)
                Text("Continue as a Guest")
                    .font(.title3)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.yellow)
            .clipShape(.rect(cornerRadius: 10))
        })
    }
    
    private var googleSignInButton: some View {
        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await vm.signInGoogle()
                        isAuth = true
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        .padding(.leading, UIScreen.main.bounds.width * 0.2)
        .frame(height: 55)
        .background(.blue)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        AuthView(authManager: AuthManager(), userManager: UserManager(), isAuth: .constant(true))
    }
}
