//
//  AdminPanelViewModel.swift
//  cos_store
//
//  Created by Vlad Sushko on 07/05/2024.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import Combine

@MainActor
final class OrderPanelViewModel: ObservableObject {
    
    @Published var allOrders: [Order] = []
    @Published var lastDocument: DocumentSnapshot? = nil
    @Published var selectedStatus: StatusOption? = nil
    
    let storageManager: StorageManager
    let productManager: ProductManager
    let orderManager: OrderManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(storageManager: StorageManager, productManager: ProductManager, orderManager: OrderManager) {
        self.storageManager = storageManager
        self.productManager = productManager
        self.orderManager = orderManager
    }
    
    enum StatusOption: String, CaseIterable {
            case orderCreated = "Order created"
            case waitingForPayment = "Waiting for payment"
            case paymantAccepted = "Paymant accepted"
            case processingInProgress = "Processing in progress"
            case shipped = "Shiped"
            case delivered = "Delivered"
            case canceled = "Canceled"
            case refunded = "Refunded"
            case allStatuses = "All Statuses"
        
        var statusKey: String? {
            if self == .allStatuses {
                return nil
            }
            return self.rawValue
        }
    }
    
    func statusSelected(status: StatusOption) async throws {
        self.selectedStatus = status
        self.allOrders = []
        self.lastDocument = nil
        self.getAllOrders()
    }
    
    func getAllOrders() {
        Task {
            let (orders, lastDocument) = try await
            orderManager.getOrders(byStatus: selectedStatus?.statusKey, count: 4, lastDocument: lastDocument)
            
            self.allOrders = orders.sorted(by: {$0.dateCreated > $1.dateCreated})
            
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func addListenerForOrders() {
        orderManager.addListenerForGlobalOrders()
            .sink { completion in
                
            } receiveValue: { [weak self] orders in
                self?.allOrders = orders
            }
            .store(in: &cancellables)
    }
    
    func getGlobalOrders() async throws {
        self.allOrders = try await orderManager.getGlobalOrders()
    }
    
    func addProduct(product: Product) async throws {
        try await productManager.addProduct(product: product)
    }
    
    func getOrder(orderId: String) async throws -> Order {
        try await orderManager.getOrderFromGlobalCollection(orderId: orderId)
    }
    
    func changeOrderStatus(orderId: String, userId: String, status: String) async throws {
        try await orderManager.changeOrderStatus(orderId: orderId, userId: userId, status: status)
    }
}


