//
//  StorageManager.swift
//  cos_store
//
//  Created by Vlad Sushko on 07/05/2024.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    private let storage = Storage.storage().reference()
    
    private var productImagesReference: StorageReference {
        storage.child("productImages")
    }
    
    private func productImageReference(productId: String) -> StorageReference {
        storage.child("products").child(productId)
    }
    
    func getData(productId: String, path: String) async throws -> Data {
        try await productImageReference(productId: productId).child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
    func saveImage(data: Data, productId: String) async throws  -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = UUID().uuidString
        let returnedMetaData = try await productImageReference(productId: productId).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path,
              let returnedName = returnedMetaData.name else {
            throw URLError(.badURL)
        }
        
        return (returnedPath, returnedName)
    }
    
    func saveImage(image: UIImage, productId: String) async throws  -> (path: String, name: String) {
        guard let data = image.jpegData(compressionQuality: 0.1) else {
            throw URLError(.badURL)
        }
        
        return try await saveImage(data: data, productId: productId)
    }
}
