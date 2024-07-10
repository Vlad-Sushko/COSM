//
//  FavoriteViewModel.swift
//  cos_store
//
//  Created by Vlad Sushko on 16/05/2024.
//

import Foundation

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var products: [(userFavoriteProduct: UserFavoriteProduct, product: Product)] = []
    
    private let userManager: UserManager
    private let productManager: ProductManager
    
    init(userManager: UserManager, productManager: ProductManager) {
        self.userManager = userManager
        self.productManager = productManager
    }
    

    
    func removeFromFavorites(userId: String, favoriteProductId: String) {
        Task {
            try await userManager.removeFavoriteProduct(userId: userId, favoriteProductId: favoriteProductId)
            getFavorites(userId: userId)
        }
    }
}
