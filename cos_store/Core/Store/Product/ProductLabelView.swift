//
//  FavoritesListView.swift
//  cos_store
//
//  Created by Vlad Sushko on 28/05/2024.
//

import SwiftUI

struct ProductLabelView: View {
    
    let productManager: ProductManager
    let productId: String
    
    @State private var product: Product? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            if let product {
                HStack(alignment: .center) {
                    NavigationLink(destination: ProductView(product: product)) {
                        ProductImageView(product: product, storageManager: StorageManager(), imageSize: .small)
                            .frame(width: 80 ,height: 80)
                            .clipShape(.rect(cornerRadius: 8))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 6)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(product.title ?? "No title")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: 200, alignment: .leading)
                        
                        Text(product.brand ?? "?")
                            .font(.subheadline)
                        
                        HStack {
                            priceSection
                            Text("/ \(product.weight ?? "")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .task {
            self.product = try? await productManager.getProduct(productID: productId)
        }
    }
}

extension ProductLabelView {
    private var priceSection: some View {
        VStack {
            if let product = product {
                if let price = product.price {
                    if let salePrice = product.salePrice {
                        HStack {
                            Text("$ \(salePrice.asNumberString())")
                                .font(.footnote)
                                .foregroundStyle(.pink)
                                .bold()
                            Text("$\(price.asNumberString())")
                                .font(.footnote)
                                .strikethrough()
                                .bold()
                        }
                    } else {
                        Text("$ \(price.asNumberString())")
                            .font(.footnote)
                            .bold()
                    }
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        ProductLabelView(productManager: ProductManager(), productId: DeveloperPreview.instance.productId)
    }
}


