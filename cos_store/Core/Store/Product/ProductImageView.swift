//
//  ProductImageView.swift
//  cos_store
//
//  Created by Vlad Sushko on 13/05/2024.
//

import SwiftUI

struct ProductImageView: View {
    
    let product: Product
    let storageManager: StorageManager
    
    @State var imageSize: ImageSize
    
    @State var imageData: Data? = nil
    
    enum ImageSize {
        case small
        case medium
        case large
    }
    
    var body: some View {
        VStack {
            if let imageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .overlay(alignment: .topLeading, content: {
                        saleLabel
                    })
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
            }
        }
        .foregroundStyle(.white)
        .onAppear {
            Task {
                if let path = product.imagePath {
                    imageData = try await storageManager.getData(productId: product.id, path: path)
                }
            }
        }
    }
}

extension ProductImageView {
    private var saleLabel: some View {
        VStack {
            if let salePrice = product.salePrice,
               let price = product.price {
                let salePercentage = ((price - salePrice) / price * 100).asNumberStringWithoutDecimals()
                
                switch(imageSize) {
                case .small:
                    Text("-\(salePercentage)%")
                        .font(.caption)
                        .padding(2)
                        .background(.pink)
                        .padding(.top, 2)
                case .medium:
                    Text("-\(salePercentage)%")
                        .padding(4)
                        .background(.pink)
                        .padding(.top, 8)
                case .large:
                    Text("-\(salePercentage)%")
                        .padding(15)
                        .background(.pink)
                        .padding(.top, 15)
                }
            }
        }
    }
}

#Preview {
    ProductImageView(product: DeveloperPreview.instance.product, storageManager: StorageManager(), imageSize: .large)
}
