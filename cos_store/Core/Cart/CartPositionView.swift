//
//  ProductCartLabel.swift
//  cos_store
//
//  Created by Vlad Sushko on 17/03/2024.
//

import SwiftUI

struct CartPositionView: View {
    
    @EnvironmentObject private var vm: RootViewModel
    
    var cartPosition: CartPosition
    
    @State private var product: Product? = nil
    @State private var quantity: Int = 1
    
    
    var body: some View {
        HStack(alignment: .top) {
            if let product = product {
                NavigationLink {
                    ProductView(product: product, vm: _vm)
                } label: {
                    ProductImageView(product: product, storageManager: vm.storageManager, imageSize: .small)
                        .frame(width: 80, height: 80)
                        .frame(maxHeight: .infinity, alignment: .center)
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    positionTitle
                    priceSection
                    weightSection
                }
                .overlay(alignment: .bottomTrailing) {
                    stepperQuantitySection
                }
                .overlay(alignment: .topTrailing) {
                    Button(action: {
                        vm.removeCartPosition(productId: cartPosition.id)
                        Task {
                            try await vm.getProductsInCart(userId: vm.userId)
                        }
                    }, label: {
                        Image(systemName: "trash")
                            .font(.title2)
                    })
                    .tint(.secondary)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
            }
        }
        .padding(6)
        .background(.thinMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .onAppear {
            Task {
                await vm.getProductsFromCartPositions()
                self.product = try await vm.getProductFromCartPosition(cartPosition: cartPosition)
                quantity = cartPosition.count
            }
        }
    }
    
    private var positionTitle: some View {
        HStack(alignment: .top) {
            Text((product?.brand ?? "") + " " + (product?.title ?? "title"))
                .lineLimit(2)
                .font(.subheadline)
                .padding(.top, 4)
                .frame(height: 50, alignment: .top)
                .padding(.trailing, 18)
            
            Spacer()
        }
    }
    
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
    
    private var weightSection: some View {
        VStack(alignment: .leading) {
            Text(product?.weight ?? "Unknown weight")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var stepperQuantitySection: some View {
        HStack {
            Button(action: {
                Task {
                    if quantity > 1 && quantity <= 15 {
                        quantity -= 1
                        try await vm.changeCartPositionCount(count: quantity, userId: vm.userId, cartPositionId: cartPosition.id)
                        try await vm.getProductsInCart(userId: vm.userId)
                    }
                }
            }, label: {
                Image(systemName: "minus.circle")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            
            Text("\(quantity)")
                .frame(width: 22)
                .padding(.trailing, 2)
            
            Button(action: {
                Task {
                    if quantity >= 1 && quantity < 15 {
                        quantity += 1
                        try await vm.changeCartPositionCount(count: quantity, userId: vm.userId, cartPositionId: cartPosition.id)
                        try await vm.getProductsInCart(userId: vm.userId)
                    }
                }
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
        }
    }
}

#Preview {
    CartPositionView(cartPosition: DeveloperPreview.instance.cartPosition)
        .environmentObject(RootViewModel())
}
