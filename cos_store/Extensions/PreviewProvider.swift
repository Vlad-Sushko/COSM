//
//  PreviewProvider.swift
//  cos_store
//
//  Created by Vlad Sushko on 15/03/2024.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {}
    
    let productId = "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203"
    
    let product = Product(id: "87F5BA0A-DFA9-4EE3-A994-93B81EBFF528",
                          title: "Daily toner pad",
                          brand: "Needly",
                          category: "toner",
                          price: 26.98,
                          salePrice: 24.28,
                          description: "Gentle and mild daily Toner Pad for daily use. Quadruple pore Improvement(number, area, volume and depth of pores)",
                          weight: "280g (60 sheets)",
                          manufacturer: "E&C CO., LTD",
                          ingridients: "Fake: Water, Glycerin, Diprophlene Glycol, Clyceryl Glucoside, 1,2-Hexanediol, Allantoin, Ethyl hesylglycerin, C12-14 Pareth-12, Beraine, Caprylyl Glycol....",
                          rating: 0,
                          image: "needlyProduct1",
                          imagePath: "B3322511-0C83-44C6-A411-AF51289607BD")
    
    let products: [Product] = [
        Product(id: "1008",
                title: "Daily toner pad",
                brand: "Needly",
                category: "toner", 
                price: 26.98,
                description: "Gentle and mild daily Toner Pad for daily use. Quadruple pore Improvement(number, area, volume and depth of pores)",
                weight: "280g (60 sheets)",
                manufacturer: "E&C CO., LTD",
                ingridients: "Fake: Water, Glycerin, Diprophlene Glycol, Clyceryl Glucoside, 1,2-Hexanediol, Allantoin, Ethyl hesylglycerin, C12-14 Pareth-12, Beraine, Caprylyl Glycol....",
                rating: 0,
                image: "needlyProduct1"),
        
        Product(id: "1009",
                title: "Vita C Glow Toning Ampoule 30ml",
                brand: "Needly",
                category: "toner", 
                price: 23.64,
                description: "Gentle and mild daily Toner Pad for daily use. Quadruple pore Improvement(number, area, volume and depth of pores)",
                weight: "30 ml",
                manufacturer: "E&C CO., LTD",
                ingridients: "Fake: Water, Glycerin, Diprophlene Glycol, Clyceryl Glucoside, 1,2-Hexanediol, Allantoin, Ethyl hesylglycerin, C12-14 Pareth-12, Beraine, Caprylyl Glycol....",
                rating: 4,
                image: "needlyProduct2"),
        
        Product(id: "1010",
                title: "Vegan mild moisture sun 50ml",
                brand: "Needly",
                category: "mask", 
                price: 22.73,
                description: "Gentle and mild daily Toner Pad for daily use. Quadruple pore Improvement(number, area, volume and depth of pores)",
                weight: "50ml",
                manufacturer: "E&C CO., LTD",
                ingridients: "Fake: Water, Glycerin, Diprophlene Glycol, Clyceryl Glucoside, 1,2-Hexanediol, Allantoin, Ethyl hesylglycerin, C12-14 Pareth-12, Beraine, Caprylyl Glycol....",
                rating: 0,
                image: "needlyProduct3"),
        
        
    ]
    
    let cartPosition: CartPosition = CartPosition(id: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                                                  productId: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                                                  price: 29.5,
                                                  count: 2,
                                                  salePrice: 24)
    
    
    let cartPositions: [CartPosition] = [
        CartPosition(id: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                     productId: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                     price: 29.5,
                     count: 2,
                     salePrice: 24),
        
        CartPosition(id: "05985D3D-3A8E-4EC3-B870-7D1A998E9CD6",
                     productId: "05985D3D-3A8E-4EC3-B870-7D1A998E9CD6",
                     price: 45,
                     count: 1)
    ]
    
    let postImageSet: [String] = ["post1", "post2", "post3", "post4"]
    
    let order: Order = Order(id: UUID().uuidString,
                             userId: UUID().uuidString,
                             userEmail: "user@gmail.com",
                             positions: [
                                CartPosition(id: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                                             productId: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                                             price: 29.5,
                                             count: 2,
                                             salePrice: 24),
                                
                                CartPosition(id: "05985D3D-3A8E-4EC3-B870-7D1A998E9CD6",
                                             productId: "05985D3D-3A8E-4EC3-B870-7D1A998E9CD6",
                                             price: 45,
                                             count: 1)
                             ],
                             status: Order.OrderStatus.orderCreated.rawValue,
                             paymentMethod: Order.PaymentMethod.Cash.rawValue,
                             paymentStatus: Order.PaymentStatus.inProcess.rawValue,
                             total: 88.00,
                             deliveryInformation: DeliveryInformation(firstName: "Jhon",
                                                                      lastName: "Trawoltra",
                                                                      phoneNumber: "555661222",
                                                                      email: "test@gmail.com",
                                                                      country: "USA",
                                                                      city: "NEW-YORK",
                                                                      postalCode: "222-333",
                                                                      address: "Main Square 22/5"),
                             dateCreated: Date.now)
    
    let orders: [Order] = [
        Order(id: UUID().uuidString,
              userId: UUID().uuidString,
              userEmail: "user@gmail.com",
              positions: [
                CartPosition(id: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                             productId: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                             price: 29.5,
                             count: 2,
                             salePrice: 24),
                
                CartPosition(id: "05985D3D-3A8E-4EC3-B870-7D1A998E9CD6",
                             productId: "05985D3D-3A8E-4EC3-B870-7D1A998E9CD6",
                             price: 45,
                             count: 1)
              ],
              status: Order.OrderStatus.orderCreated.rawValue,
              paymentMethod: Order.PaymentMethod.Cash.rawValue,
              paymentStatus: Order.PaymentStatus.inProcess.rawValue,
              total: 88.00,
              deliveryInformation: DeliveryInformation(firstName: "Jhon",
                                                       lastName: "Trawoltra",
                                                       phoneNumber: "555661222",
                                                       email: "test@gmail.com",
                                                       country: "USA",
                                                       city: "NEW-YORK",
                                                       postalCode: "222-333",
                                                       address: "Main Square 22/5"),
              dateCreated: Date.now),
        
        Order(id: UUID().uuidString,
              userId: UUID().uuidString,
              userEmail: "user@gmail.com",
              positions: [
                CartPosition(id: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                             productId: "0361CFEC-EC3B-43F9-86C7-7B0B19BE8203",
                             price: 29.5,
                             count: 2,
                             salePrice: 24),
                
                CartPosition(id: "05985D3D-3A8E-4EC3-B870-7D1A998E9CD6",
                             productId: "05985D3D-3A8E-4EC3-B870-7D1A998E9CD6",
                             price: 45,
                             count: 1)
              ],
              status: Order.OrderStatus.orderCreated.rawValue,
              paymentMethod: Order.PaymentMethod.Cash.rawValue,
              paymentStatus: Order.PaymentStatus.inProcess.rawValue,
              total: 88.00,
              deliveryInformation: DeliveryInformation(firstName: "Jhon",
                                                       lastName: "Trawoltra",
                                                       phoneNumber: "555661222",
                                                       email: "test@gmail.com",
                                                       country: "USA",
                                                       city: "NEW-YORK",
                                                       postalCode: "222-333",
                                                       address: "Main Square 22/5"),
              dateCreated: Date.now)]
    
    
}
