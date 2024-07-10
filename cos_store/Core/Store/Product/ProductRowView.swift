//
//  ProductRowView.swift
//  cos_store
//
//  Created by Vlad Sushko on 15/03/2024.
//

import SwiftUI

struct ProductRowView: View {
    
    @EnvironmentObject var vm: RootViewModel
    
    var product: Product
    @State var isFavorite: Bool = false
    
    var body: some View {
        VStack {
            ProductImageView(product: product, storageManager: StorageManager(), imageSize: .medium)
                .frame(height: 150)
            
            VStack(alignment: .leading) {
                titleText
                
                HStack(spacing: 5) {
                    productBrandText
                    productCategoryText
                }
                productWeightText
                priceSection
            }
            .padding(.horizontal, 4)
        }
        .frame(width: UIScreen.main.bounds.width / 2.3)
        .padding(.bottom, 6)
        .background(.ultraThickMaterial)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 6)
        .overlay(alignment: .bottomTrailing, content: {
            cartButton
                .padding(12)
        })
        .overlay(alignment: .topTrailing) {
            favoriteButton
        }
        .onAppear {
            if vm.favoritesProducts.contains(where: { $0.id == product.id }) {
                isFavorite = true
            } else {
                isFavorite = false
            }
        }
    }
}

extension ProductRowView {
    private var titleText: some View {
        Text(product.title ?? "")
            .font(.footnote)
            .bold()
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 35)
    }
    
    private var productBrandText: some View {
        Text(product.brand ?? "")
            .font(.footnote)
            .bold()
    }
    
    private var productCategoryText: some View {
        Text(product.category ?? "")
            .foregroundStyle(.secondary)
            .font(.footnote)
    }
    
    private var productWeightText: some View {
        Text(product.weight ?? "Unknown weight")
            .font(.footnote)
            .italic()
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }
    
    private var priceSection: some View {
        VStack {
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
    
    private var cartButton: some View {
        Button(action: {
            Task {
                try await vm.addProductToCart(productId: product.id)
            }
        }, label: {
            Image(systemName: "cart.badge.plus")
                .font(.title2)
                .padding(4)
        })
    }
    
    private var favoriteButton: some View {
        Button(action: {
            isFavorite.toggle()
            if isFavorite {
                vm.addUserFavoriteProduct(productId: product.id)
            } else {
                vm.removeFromFavorites(favoriteProductId: product.id)
            }
        }, label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .tint(.pink)
                .padding()
        })
    }
}

#Preview {
    VStack {
        ProductRowView(product: DeveloperPreview.instance.product)
            .environmentObject(RootViewModel())
    }
    .padding(.horizontal)
}
