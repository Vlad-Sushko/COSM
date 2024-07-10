//
//  ProductManager.swift
//  cos_store
//
//  Created by Vlad Sushko on 06/05/2024.
//

import Foundation
import FirebaseFirestore


final class ProductManager {
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
       encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
       decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func updateProductImagePath(productId: String, path: String) async throws {
        let data: [String: Any] = [
            Product.CodingKeys.imagePath.rawValue : path
        ]
        
        try await productDocument(productId: productId).updateData(data)
    }
    
    func addProduct(product: Product) async throws {
        try productDocument(productId: product.id).setData(from: product, merge: false, encoder: encoder)
    }
    
    func getProduct(productID: String) async throws -> Product {
        try await productDocument(productId: productID).getDocument(as: Product.self)
    }
    
    func getProductPrice(productID: String) async throws -> Double? {
        let product = try await productDocument(productId: productID).getDocument(as: Product.self)
        return product.price
    }
    
    func getProductSalePrice(productID: String) async throws -> Double? {
        let product = try await productDocument(productId: productID).getDocument(as: Product.self)
        return product.salePrice
    }
    
    private func getProductsQuery() -> Query {
        productsCollection
    }
    
    private func getProductsSortedByBrand(brand: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.brand.rawValue, isEqualTo: brand)
    }
    
    private func getProductsSortedByPriceQuery(descending: Bool) -> Query {
        productsCollection
            .order(by: Product.CodingKeys.price.rawValue,descending: descending)
    }
    
    private func getProductsForCategoryQuery(category: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    private func getProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getProductsByPriceAndBrandQuery(descending: Bool, selectedBrand: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.brand.rawValue, isEqualTo: selectedBrand)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getProductsByCategoryAndBrandQuery(category: String, selectedBrand: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.brand.rawValue, isEqualTo: selectedBrand)
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    private func getProductsByPriceByCategoryAndBrandQuery(descending: Bool, category: String, selectedBrand: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.brand.rawValue, isEqualTo: selectedBrand)
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    // MARK: MAIN COLLECTION
    func getProducts(priceDescending descending: Bool?, forCategory category: String?, selectedBrand: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (collection: [Product], lastDocument: DocumentSnapshot?) {
        
        var query: Query = getProductsQuery()
        
        if let descending, let category, let selectedBrand {
            query = getProductsByPriceByCategoryAndBrandQuery(descending: descending, category: category, selectedBrand: selectedBrand)
        } else if let selectedBrand, let descending {
            query = getProductsByPriceAndBrandQuery(descending: descending, selectedBrand: selectedBrand)
        } else if let selectedBrand, let category {
            query = getProductsByCategoryAndBrandQuery(category: category, selectedBrand: selectedBrand)
        } else if let descending, let category {
            query = getProductsByPriceAndCategoryQuery(descending: descending, category: category)
        } else if let descending {
            query = getProductsSortedByPriceQuery(descending: descending)
        } else if let category {
            query = getProductsForCategoryQuery(category: category)
        } else if let selectedBrand {
            query = getProductsSortedByBrand(brand: selectedBrand)
        }
        
        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Product.self)
    }
    
    func getProductsCount() async throws -> Int {
        try await productsCollection.aggregateCount()
    }
}


