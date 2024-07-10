//
//  DatabaseManager.swift
//  cos_store
//
//  Created by Vlad Sushko on 22/04/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

final class UserManager {
    
    private let userCollection = Firestore.firestore().collection("users")
    private var userFavoriteProductsListener: ListenerRegistration? = nil
    private var userCartPositionsListener: ListenerRegistration? = nil
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    // MARK: - USER
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    
    @discardableResult
    func getUser(userId: String) async throws -> DBUser? {
        try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
    }
    
    func checkRegistrationInDatabase(authManager: AuthManager) async throws {
        let currentUser = try authManager.getAuthenticatedUser()
        do {
            try await getUser(userId: currentUser.uid)
        } catch {
            try await createNewUser(user: DBUser(auth: currentUser))
        }
    }
    
    func updateUserName(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
    }
    
    func updateUserName(userID: String, newName: String) async throws {
        let data: [String: Any] = [
            "name" : newName
        ]
        try await userDocument(userId: userID).updateData(data)
    }
    
    
    // MARK: - FAVORITES
    private func favoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_products")
    }
    
    private func favoriteProductDocument(userId: String, favoriteProductId: String) -> DocumentReference {
        favoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
    func addFavoriteProduct(userId: String, productId: String) async throws {
        let document = favoriteProductCollection(userId: userId).document(productId)
        let documentId = document.documentID
        
        let data: [String: Any] = [
            DBUserFavoriteProduct.CodingKeys.id.rawValue : documentId,
            DBUserFavoriteProduct.CodingKeys.productId.rawValue : productId,
        ]
        
        try await document.setData(data, merge: true)
    }
    
    func removeFavoriteProduct(userId: String, favoriteProductId: String) async throws {
        try await favoriteProductDocument(userId: userId, favoriteProductId: favoriteProductId).delete()
    }
    
    func getAllFavoriteProducts(userId: String) async throws -> [DBUserFavoriteProduct] {
        try await favoriteProductCollection(userId: userId).getDocuments(as: DBUserFavoriteProduct.self)
    }
    
    func removeListenerForAllFavoriteProducts() {
        self.userFavoriteProductsListener?.remove()
    }
    
    func addListenerForGetAllFavoriteProducts(userId: String) ->  AnyPublisher<[DBUserFavoriteProduct], Error> {
        let (publisher, listener) = favoriteProductCollection(userId: userId)
            .addSnapshotListener(as: DBUserFavoriteProduct.self)
        
        self.userFavoriteProductsListener = listener
        return publisher
    }
    
    
    // MARK: - CART
    private func cartCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("cart")
    }
    
    private func cartDocument(userId: String, cartPositionId: String) -> DocumentReference {
        cartCollection(userId: userId).document(cartPositionId)
    }
    
    func addListenerForGetCartPositions(userId: String) ->  AnyPublisher<[CartPosition], Error> {
        let (publisher, listener) = cartCollection(userId: userId)
            .addSnapshotListener(as: CartPosition.self)
        
        self.userCartPositionsListener = listener
        return publisher
    }
    
    func addProductToCart(userId: String, productId: String, price: Double, salePrice: Double? = nil, count: Int) async throws {
        let document = cartCollection(userId: userId).document(productId)
        let documentId = document.documentID
        
        let data: [String: Any?] = [
            CartPosition.CodingKeys.id.rawValue : documentId,
            CartPosition.CodingKeys.productId.rawValue : productId,
            CartPosition.CodingKeys.price.rawValue : price,
            CartPosition.CodingKeys.salePrice.rawValue : salePrice,
            CartPosition.CodingKeys.count.rawValue : count,
        ]
        
        try await document.setData(data as [String : Any], merge: true)
    }
    
    func getProductsInCart(userId: String) async throws -> [CartPosition] {
        try await cartCollection(userId: userId).getDocuments(as: CartPosition.self)
    }
    
    func removeCartProduct(userId: String, productId: String) async throws {
        try await cartDocument(userId: userId, cartPositionId: productId).delete()
    }
    
    func removeCartProducts(userId: String, cartPositions: [CartPosition]) async throws {
        for position in cartPositions {
            try await cartDocument(userId: userId, cartPositionId: position.id).delete()
        }
    }
    
    func increaseCartPositionCount(count: Int, userId: String, cartPositionId: String) async throws {
        let data: [String: Any] = [
            CartPosition.CodingKeys.count.rawValue : count
        ]
        
        try await cartDocument(userId: userId, cartPositionId: cartPositionId).updateData(data)
    }
}







