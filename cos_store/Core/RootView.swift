//
//  HomeView.swift
//  cs_platform
//
//  Created by Vlad Sushko on 14/03/2024.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var vm = RootViewModel()
    
    @Binding var isAuth: Bool
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    MainView(selectedTab: $selectedTab)
                        .tabItem { Label("Main", systemImage: "house")
                        }
                        .tag(0)
                    
                    StoreView()
                        .tabItem { Label("Products", systemImage: "bag.badge.plus")
                        }
                        .tag(1)
                    
                    if vm.userId == "rawtSLeVAVde80awPuAInp82nDy2" {
                        AdminPanel()
                            .tabItem { Label("Admin Panel", systemImage: "person.fill.viewfinder") }
                            .tag(2)
                    } else {
                        FavoritesView()
                            .tabItem( { Label("Favorites", systemImage: "heart.fill")
                            })
                            .tag(2)
                    }
                    
                    CartView(selectedTab: $selectedTab)
                        .tabItem { Label("Cart", systemImage: "basket")
                        }
                        .tag(3)
                    
                    ProfileView(isAuth: $isAuth)
                        .tabItem { Label("Account", systemImage: "sidebar.squares.trailing")
                        }
                        .tag(4)
                }
                .tabViewStyle(.automatic)
                .tint(.accent)
            }
        }
        .environmentObject(vm)
    }
}

#Preview {
    NavigationStack {
        RootView(isAuth: .constant(true))
            .environmentObject(RootViewModel())
    }
}
