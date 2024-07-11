//
//  ProfileView.swift
//  cos_store
//
//  Created by Vlad Sushko on 24/04/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var vm: RootViewModel
    
    @Binding var isAuth: Bool
    
    @State private var errorMessage: String? = nil
    @State private var showAuthorizationView: Bool = false
    @State private var showConfirmationDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading) {
                    welcomeSection
                    VStack(spacing: 15) {
                        HStack {
                            if let orders = vm.orders {
                                NavigationLink {
                                    OrdersView(orders: orders)
                                } label: {
                                    ordersLabel
                                }
                            }
                        }
                        
                        Divider()
                        
                        addressSection
                        
                        Divider()
                        
                       accountLabel
                    }
                    .foregroundStyle(.primary)
                    .padding()
                    .background()
                    .clipShape(.rect(cornerRadius: 15))
                    .padding()
                    .shadow(radius: 10)
                    settingsSection
                    
                    Spacer()
                    
                    logoutButton
                }
                .padding(.vertical, 20)
                .onAppear {
                    vm.loadAuthProviders()
                    vm.loadAuthUser()
                    Task {
                        try? await vm.loadCurrentUser()
                        try await vm.getUserOrders()
                    }
                }
                .alert(errorMessage ?? "Error", isPresented: Binding(value: $errorMessage)) {
                    Button(action: {}, label: {
                        Text("OK")
                    })
                }
                .confirmationDialog("Are you sure to logout?",
                                    isPresented: $showConfirmationDialog,
                                    titleVisibility: .visible) {
                    Group {
                        Button("Logout", role: .destructive) {
                            Task {
                                do {
                                    try vm.signOut()
                                    isAuth = false
                                }
                                catch {
                                    errorMessage = error.localizedDescription
                                }
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(isAuth: .constant(true))
            .environmentObject(RootViewModel())
    }
}

extension ProfileView {
    
    private var ordersLabel: some View {
        HStack {
            Image(systemName: "creditcard")
            Text("Orders")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    private var accountLabel: some View {
        HStack {
            Image(systemName: "clock.badge.checkmark")
            Image(systemName: "person")
            Text("Account")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    private var welcomeSection: some View {
        HStack {
            Image(systemName: "person")
                .font(.headline)
            
            if let name = vm.user?.name {
                Text(name)
                    .bold()
            } else {
                Text("Guest")
            }
        }
        .padding(.horizontal)
    }
    
    private var ordersSection: some View {
        HStack {
            Image(systemName: "creditcard")
            Text("Orders")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    private var addressSection: some View {
        HStack {
            Image(systemName: "clock.badge.checkmark")
            Image(systemName: "location")
            Text("Address")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    private var settingsSection: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "clock.badge.checkmark")
                Image(systemName: "bell")
                Text("Notifications")
                Spacer()
                Image(systemName: "chevron.right")
            }
            
            Divider()
            
            HStack {
                Image(systemName: "clock.badge.checkmark")
                Image(systemName: "l.circle")
                Text("Language")
                Spacer()
                Image(systemName: "chevron.right")
            }
            
            Divider()
            
            HStack {
                Image(systemName: "clock.badge.checkmark")
                Image(systemName: "eurosign")
                Text("Currency")
                Spacer()
                Image(systemName: "chevron.right")
            }
            
            Divider()
            
            HStack {
                Image(systemName: "clock.badge.checkmark")
                Image(systemName: "headphones")
                Text("Support")
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.primary)
        .padding()
        .background()
        .clipShape(.rect(cornerRadius: 15))
        .padding()
        .shadow(radius: 10)
    }
    
    private var accountSection: some View {
        VStack(spacing: 15) {
            ordersSection
            
            Divider()
            
            addressSection
            
            Divider()
            
            HStack {
                Image(systemName: "person")
                Text("Account")
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.primary)
        .padding()
        .background()
        .clipShape(.rect(cornerRadius: 15))
        .padding()
        .shadow(radius: 10)
    }
    
    
    private var logoutButton: some View {
        Button {
            showConfirmationDialog.toggle()
        } label: {
            Text(vm.authUser?.isAnomymous == true ? "REGISTER" : "Logout")
                .foregroundStyle(.white)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(.black)
                .clipShape(.rect(cornerRadius: 15))
        }
        .padding(.horizontal)
    }
}
