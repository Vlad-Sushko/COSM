//
//  SignUpWithEmailView.swift
//  cos_store
//
//  Created by Vlad Sushko on 25/04/2024.
//

import SwiftUI

struct SignUpWithEmailView: View {
    
    @StateObject var vm: AuthViewModel
    @State private var errorMessage: String? = nil
    
    init(authManager: AuthManager, userManager: UserManager) {
        _vm = StateObject(wrappedValue: AuthViewModel(authManager: authManager, userManager: userManager))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleSection
            emailSection
            passwordSection
            fullNameSection
            signUpButton
        }
        .padding()
        .background(.grayBG.opacity(0.4))
        .clipShape(.rect(cornerRadius: 16))
        .alert(errorMessage ?? "Error", isPresented: Binding(value: $errorMessage)) {
            Button(action: {}, label: {
                Text("OK")
            })
        }
    }
}

extension SignUpWithEmailView {
    private var titleSection: some View {
        Text("SIGN UP WITH EMAIL")
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 14)
    }
    private var emailSection: some View {
        VStack(alignment: .leading) {
            Text("EMAIL ADDRESS")
                .font(.headline)
                .bold()
                .foregroundStyle(.grayBG)
            
            TextField("Email address..", text: $vm.email)
                .textInputAutocapitalization(.never)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    private var passwordSection: some View {
        VStack(alignment: .leading) {
            Text("PASSWORD")
                .font(.headline)
                .bold()
                .foregroundStyle(.grayBG)
            
            SecureField("Password..", text: $vm.password)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    private var fullNameSection: some View {
        VStack(alignment: .leading) {
            Text("FULL NAME")
                .font(.headline)
                .bold()
                .foregroundStyle(.grayBG)
            
            TextField("Full name..", text: $vm.name)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    private var signUpButton: some View {
        Button(action: {
            Task {
                do {
                    try await vm.registerUser(name: vm.name)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }, label: {
            HStack {
                Text("Sign up")
                    .bold()
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.grayBG)
            .clipShape(.rect(cornerRadius: 10))
        })
        .padding(.top, 10)
    }
}

#Preview {
    SignUpWithEmailView(authManager: AuthManager(), userManager: UserManager())
        .padding()
}
