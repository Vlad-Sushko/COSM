//
//  FavoritesView.swift
//  cos_store
//
//  Created by Vlad Sushko on 16/05/2024.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var vm: RootViewModel
    
    @State private var didAppear: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(vm.favoritesProducts, id: \.self.id) { item in
                        ProductLabelView(productManager: vm.productManager, productId: item.id)
                            .padding(.horizontal)
                            .overlay(alignment: .topTrailing, content: {
                                Button(action: {
                                    vm.removeFromFavorites(favoriteProductId: item.id)
                                }, label: {
                                    deleteFavoriteIcon
                                })
                                .tint(.pink)
                                
                            })
                            .overlay(alignment: .bottomTrailing, content: {
                                Button(action: {
                                    Task {
                                        try await vm.addProductToCart(productId: item.id)
                                    }
                                }, label: {
                                    cartIcon
                                })
                                
                            })
                    }
                    .navigationTitle("Favorites")
                }
                .onFirstAppear {
                    vm.addListenerForFavorites()
                }
            }
        }
    }
}

extension FavoritesView {
    private var deleteFavoriteIcon: some View {
        Image(systemName: "heart.slash.circle.fill")
            .font(.title)
            .padding(8)
            .padding(.trailing, 10)
    }
    
    private var cartIcon: some View {
        Image(systemName: "cart.badge.plus")
            .font(.title2)
            .padding(8)
            .padding(.trailing, 10)
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
            .environmentObject(RootViewModel())
    }
}



