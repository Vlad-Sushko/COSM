//
//  CartPosition.swift
//  cos_store
//
//  Created by Vlad Sushko on 21/05/2024.
//

import Foundation

struct CartPosition: Codable, Hashable {
    let id: String
    let productId: String
    let price: Double
    let salePrice: Double?
    let count: Int
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case productId = "product_id"
        case price = "price"
        case salePrice = "sale_price"
        case count = "count"
    }
    
    init(id: String, productId: String, price: Double, count: Int, salePrice: Double? = nil) {
        self.id = id
        self.productId = productId
        self.price = price
        self.salePrice = salePrice
        self.count = count
    }
}
