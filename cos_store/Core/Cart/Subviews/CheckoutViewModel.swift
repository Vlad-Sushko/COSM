//
//  CheckoutViewModel.swift
//  cos_store
//
//  Created by Vlad Sushko on 28/05/2024.
//

import SwiftUI

@MainActor
final class CheckoutViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var postCode: String = ""
    @Published var address: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    @Published var order: Order? = nil
 
    let orderManager: OrderManager
    let userId: String
    
    init(orderManager: OrderManager, userId: String) {
        self.orderManager = orderManager
        self.userId = userId
    }
}
