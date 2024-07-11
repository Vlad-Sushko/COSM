//
//  ProductView.swift
//  cs_platform
//
//  Created by Vlad Sushko on 14/03/2024.
//

import SwiftUI

struct ProductView: View {
    
    let product: Product
    
    @EnvironmentObject var vm: RootViewModel
    
    @State private var quantity: Int = 1
    @State private var isFavorite: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                ProductImageView(product: product, storageManager: vm.storageManager, imageSize: .large)
                    .padding(.vertical, 8)
                    .overlay(alignment: .topTrailing) {
                        favoriteButton
                    }
                    .frame(height: 400)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        priceSection
                        cartButton
                    }
                    
                    HStack {
                        ratingSection
                        Spacer()
                        stepperQuantitySection
                    }
                    Divider()
                    titleField
                    Divider()
                    brandField
                    Divider()
                    descriptionField
                    Divider()
                    weightField
                    Divider()
                    ingridientsField
                    Divider()
                    manufacturerField
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle(product.title ?? "")
            .alert(errorMessage ?? "Error", isPresented: Binding(value: $errorMessage)) {
                Button(action: {}, label: {
                    Text("OK")
                })
            }
        }
        .scrollIndicators(.hidden)
    }
}

extension ProductView {
    private var priceSection: some View {
        VStack {
            if let price = product.price {
                if let salePrice = product.salePrice {
                    VStack {
                        Text("$\(price.asNumberString())")
                            .strikethrough()
                            .padding(.leading, 30)
                        
                        Text("$\(salePrice.asNumberString())")
                            .font(.title)
                            .foregroundStyle(.red)
                            .bold()
                            .padding(.horizontal, 8)
                    }
                } else {
                    Text("$\(price.asNumberString())")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 8)
                }
            }
        }
    }
    
    private var cartButton: some View {
        Button(action: {
            Task {
                do {
                    try await vm.addProductToCart(productId: product.id, count: quantity)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }, label: {
            Image(systemName: "cart")
                .foregroundStyle(.white)
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 40)
                .background(.black)
                .clipShape(.rect(cornerRadius: 10))
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
            .font(.largeTitle)
            .foregroundStyle(.pink)
            .padding(30)
        })
    }
    
    private var stepperQuantitySection: some View {
        Stepper(value: $quantity, in: 1...15) {
            Text("Qty: \(quantity)")
        }
        .foregroundStyle(.secondary)
        .frame(width: 160)
    }
    
    // TODO: Implement products rating
    private var ratingSection: some View {
        HStack {
            Image(systemName: "star")
            Image(systemName: "star")
            Image(systemName: "star")
            Image(systemName: "star")
            Image(systemName: "star")
        }
    }
    
    private var titleField: some View {
        HStack(alignment: .top) {
            Text("Title:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            Text(product.title ?? "")
        }
    }
    private var brandField: some View {
        HStack(alignment: .top) {
            Text("Brand:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            Text(product.brand ?? "")
        }
    }
    private var descriptionField: some View {
        HStack(alignment: .top) {
            Text("Description:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            Text(product.description ?? "")
        }
    }
    private var weightField: some View {
        HStack(alignment: .top) {
            Text("Weight:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            Text(product.weight ?? "")
        }
    }
    private var ingridientsField: some View {
        HStack(alignment: .top) {
            Text("Ingredients:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            Text(product.ingridients ?? "")
        }
    }
    private var manufacturerField: some View {
        HStack(alignment: .top) {
            Text("Manufacturer")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            Text(product.manufacturer ?? "")
        }
    }
}


#Preview {
    NavigationStack {
        ProductView(product: DeveloperPreview.instance.product)
            .environmentObject(RootViewModel())
    }
}
