//
//  OrderManager.swift
//  cos_store
//
//  Created by Vlad Sushko on 22/05/2024.
//

import Foundation
import FirebaseFirestore
import Combine

final class OrderManager {
    
    private let globalOrdersCollection = Firestore.firestore().collection("orders")
    private let userOrdersCollection = Firestore.firestore().collection("user_orders")
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userOrdersCollection(userId: String) -> CollectionReference {
        userCollection.document(userId).collection("user_orders")
    }
    private func globalOrderDocument(orderId: String) -> DocumentReference {
        globalOrdersCollection.document(orderId)
    }
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private var globalOrdersListener: ListenerRegistration? = nil
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func addListenerForGlobalOrders() -> AnyPublisher<[Order], Error> {
        let (publisher, listener) = globalOrdersCollection
            .addSnapshotListener(as: Order.self)
        
        self.globalOrdersListener = listener
        return publisher
    }
    
    // MARK: - USER ORDERS
    func getUserOrders(userId: String) async throws -> [Order] {
        try await userOrdersCollection(userId: userId).getDocuments(as: Order.self)
    }
    
    private func getOrdersQuery() -> Query {
        globalOrdersCollection
    }
    
    func createOrder(userId: String, order: Order) async throws {
        let document = userOrdersCollection(userId: userId).document(order.id)
        
        guard let orderDict = try? encoder.encode(order) else {
            throw URLError(.badURL)
        }
        
        try await document.setData(orderDict, merge: true)
    }
    
    // MARK: - GLOBAL ORDERS
    func getGlobalOrders() async throws -> [Order] {
        try await globalOrdersCollection.getDocuments(as: Order.self)
    }
    
    func getOrderFromGlobalCollection(orderId: String) async throws -> Order {
        try await globalOrderDocument(orderId: orderId).getDocument(as: Order.self)
    }
    
    func addOrderToGlobalCollection(order: Order) async throws {
        try globalOrderDocument(orderId: order.id).setData(from: order, merge: false, encoder: encoder)
    }
    
    private func getOrdersByStatusQuery(status: String) -> Query {
        globalOrdersCollection
            .whereField(Order.CodingKeys.status.rawValue, isEqualTo: status)
    }
    
    private func getOrdersByStatus(status: String) -> Query {
        globalOrdersCollection
            .whereField(Order.CodingKeys.status.rawValue, isEqualTo: status)
    }
    
    // MARK: - MAIN COLLECTION
    func getOrders(byStatus: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (collection: [Order], lastDocument: DocumentSnapshot?) {
        var query: Query = getOrdersQuery()
        
        if let byStatus {
            query = getOrdersByStatus(status: byStatus)
        }
        
        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Order.self)
    }
    
    
    func changeOrderStatus(orderId: String, userId: String, status: String) async throws {
        let data: [String: Any] = [
            "status" : status
        ]
        try await globalOrderDocument(orderId: orderId).updateData(data)
        try await userDocument(userId: userId).collection("user_orders").document(orderId).updateData(data)
    }
}
