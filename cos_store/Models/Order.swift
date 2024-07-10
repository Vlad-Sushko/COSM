//
//  Order.swift
//  cos_store
//
//  Created by Vlad Sushko on 22/05/2024.
//

import Foundation

struct Order: Codable, Equatable, Identifiable {
    
    var id: String
    let userId: String
    let userEmail: String?
    let positions: [CartPosition]?
    var status: String? // OrderStatus
    let paymentMethod: String? // PaymentMethod
    let paymentStatus: String? // PaymentStatus
    let total: Double?
    let deliveryInformation: DeliveryInformation?
    let dateCreated: Date
    
    enum PaymentMethod: String {
        case VisaMastercard = "Bank Card: VISA/MASTERCARD"
        case ApplePay = "Apple Pay"
        case GoodglePay = "Google Pay"
        case Cash = "Cash"
    }
    
    enum PaymentStatus: String {
        case received = "Received"
        case inProcess = "In process"
        case error = "Error"
        case expired = "Expired"
        case cancelled = "Canceled"
        case refunded = "Refunded"
    }
    
    enum OrderStatus: String, CaseIterable, Identifiable {
        var id: OrderStatus { self }
        
        case orderCreated = "Order created"
        case waitingForPayment = "Waiting for payment"
        case awaitingCheckPayment = "Awaiting check payment"
        case paymantAccepted = "Paymant accepted"
        case shipped = "Shiped"
        case delivered = "Delivered"
        case canceled = "Canceled"
        case refunded = "Refunded"
    }
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case userId = "user_id"
        case userEmail = "user_email"
        case positions = "positions"
        case status = "status"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
        case total = "total"
        case deliveryInformation = "delivery_information"
        case dateCreated = "date_created"
    }
    
    init(id: String,
         userId: String,
         userEmail: String? = nil,
         positions: [CartPosition]? = nil,
         status: String? = nil,
         paymentMethod: String? = nil,
         paymentStatus: String? = nil,
         total: Double? = nil,
         deliveryInformation: DeliveryInformation? = nil,
         dateCreated: Date) {
        self.id = id
        self.userId = userId
        self.userEmail = userEmail
        self.positions = positions
        self.status = status
        self.paymentMethod = paymentMethod
        self.paymentStatus = paymentStatus
        self.total = total
        self.deliveryInformation = deliveryInformation
        self.dateCreated = dateCreated
        
    }
    
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
}

