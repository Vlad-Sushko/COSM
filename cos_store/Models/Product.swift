//
//  Product.swift
//  cs_platform
//
//  Created by Vlad Sushko on 14/03/2024.
//

import Foundation

struct Product : Identifiable, Codable, Hashable, Equatable {
    let id: String
    var title: String?
    var brand: String?
    var category: String?
    var price: Double?
    var salePrice: Double?
    var description: String?
    var weight: String?
    var manufacturer: String?
    var ingridients: String?
    var rating: Double?
    var ratingQuantity: Int?
    var image: String?
    var imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case brand = "brand"
        case category = "category"
        case price = "price"
        case salePrice = "sale_price"
        case description = "description"
        case weight = "weight"
        case manufacturer = "manufacturer"
        case ingridients = "ingridients"
        case rating = "rating"
        case ratingQuantity = "rating_quantity"
        case image = "image"
        case imagePath = "image_path"
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
