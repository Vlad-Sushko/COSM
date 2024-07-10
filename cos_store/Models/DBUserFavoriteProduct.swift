//
//  UserFavoriteProduct.swift
//  cos_store
//
//  Created by Vlad Sushko on 22/05/2024.
//

import Foundation

struct DBUserFavoriteProduct: Codable {
    let id: String
    let productId: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(String.self, forKey: .productId)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productId, forKey: .productId)
    }
}
