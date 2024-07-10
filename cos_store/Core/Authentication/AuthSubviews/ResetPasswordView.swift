//
//  ResetPasswordView.swift
//  cos_store
//
//  Created by Vlad Sushko on 20/04/2024.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @StateObject private var vm: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var alertMessage: String? = nil
    @State private var errorMessage: String? = nil
    
    init(authManager: AuthManager, userManager: UserManager) {
        _vm = StateObject(wrappedValue: AuthViewModel(authManager: AuthManager(), userManager: UserManager()))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("RESET YOUR PASSWORD")
                .foregroundStyle(.secondary)
                .bold()
            Text("Type in your email address below and we'll send you an email with instructions on how to create a new password")
                .font(.subheadline)
            TextField("Email address:", text: $vm.email)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
            
            Button(action: {
                Task {
                    do {
                        try await vm.resetPassword()
                        alertMessage = "We've sent you and email to reset your password. To create your new password, click the link in the email and enter a new one - easy!"
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }, label: {
                Text("RESET PASSWORD")
                    .foregroundStyle(.white)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primary)
                    .clipShape(.rect(cornerRadius: 10))
            })
        }
        .padding()
        .padding(.vertical, 30)
        .background(.whiteBlackBG.shadow(.drop(radius: 10)))
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .tint(.primary)
                    .padding()
            }
        }
        .alert(alertMessage ?? "Alert", isPresented: Binding(value: $alertMessage)) {
            Button(action: {}, label: {
                Text("OK")
            })
        }
        .alert(errorMessage ?? "Error", isPresented: Binding(value: $errorMessage)) {
            Button(action: {}, label: {
                Text("OK")
            })
        }
    }
}


#Preview {
    ResetPasswordView(authManager: AuthManager(), userManager: UserManager())
}
