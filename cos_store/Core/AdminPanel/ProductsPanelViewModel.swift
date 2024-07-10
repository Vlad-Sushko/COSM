//
//  ProductsPanelViewModel.swift
//  cos_store
//
//  Created by Vlad Sushko on 19/06/2024.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore


@MainActor
final class ProductsPanelViewModel: ObservableObject {
    
    @Published var productImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setProductImage(from: imageSelection)
        }
    }
    
    let storageManager: StorageManager
    let productManager: ProductManager
    
    var product: Product
    
    init(productImage: UIImage? = nil, imageSelection: PhotosPickerItem? = nil, storageManager: StorageManager, productManager: ProductManager) {
        self.productImage = productImage
        self.imageSelection = imageSelection
        self.storageManager = storageManager
        self.productManager = productManager
        self.product = Product(id: UUID().uuidString)
    }
    
    func addProduct(product: Product) async throws {
        try await productManager.addProduct(product: product)
    }
    
    func setProductImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                
                guard let data,
                      let uiImage = UIImage(data: data) else {
                    throw URLError(.badURL)
                }
                productImage = uiImage
            } catch {
                print(error)
            }
        }
    }
    
    func saveProductImage(item: PhotosPickerItem, productId: String) {
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { throw URLError(.badURL) }
            let (_, name) = try await storageManager.saveImage(data: data, productId: productId)
            
            try await productManager.updateProductImagePath(productId: productId, path: name)
        }
    }
}

