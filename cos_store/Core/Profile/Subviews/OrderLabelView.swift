//
//  OrderLabelView.swift
//  cos_store
//
//  Created by Vlad Sushko on 07/06/2024.
//

import SwiftUI

struct OrderLabelView: View {
    
    @EnvironmentObject private var vm: RootViewModel
    
    @State var order: Order
    @State private var product: Product? = nil
    @State private var showDetails: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                productImageSection
                
                orderDetailsSection
            }
            if showDetails {
                orderProductsDetailsSection
            }
        }
        .padding(8)
        .background()
        .clipShape(.rect(cornerRadius: 10))
        .shadow(radius: 5)
        .padding(.horizontal)
        .onTapGesture {
            showDetails.toggle()
        }
        .onAppear {
            Task {
                if let productId = order.positions?.first?.id {
                    self.product = try await vm.productManager.getProduct(productID: productId)
                }
            }
        }
    }
}

extension OrderLabelView {
    private var productImageSection: some View {
        VStack {
            if let product = product {
                ProductImageView(product: product, storageManager: vm.storageManager, imageSize: .small)
                    .frame(width: 70, height: 75)
                    .overlay(alignment: .topTrailing) {
                        Text("\(order.positions?.count ?? 0)")
                            .font(.callout)
                            .padding(5)
                            .background(Circle().fill(.white))
                            .padding(.horizontal, 4)
                    }
            }
        }
    }
    
    private var orderDetailsSection: some View {
        VStack(alignment: .leading) {
            
            Text("\(order.id)")
                .font(.caption)
                .textSelection(.enabled)
            
            HStack {
                Text("Status: ")
                    .foregroundStyle(.secondary)
                Text(order.status ?? "Unknown status")
            }
            
            HStack {
                Text(order.dateCreated.formatted(date: .abbreviated, time: .shortened))
                Spacer()
                Text("\(order.total?.asNumberString() ?? "")$")
            }
        }
    }
    
    private var orderProductsDetailsSection: some View {
        VStack(alignment: .leading) {
            Divider()
            
            if let positions = order.positions {
                ForEach(positions, id: \.self) { position in
                    ProductLabelView(productManager: vm.productManager, productId: position.productId)
                        .overlay(alignment: .trailing) {
                            Text("Qty: \(position.count)")
                        }
                }
            }
        }
        .transition(.move(edge: .top))
    }
}

#Preview {
    Group {
        ScrollView {
            OrderLabelView(order: DeveloperPreview.instance.order)
            OrderLabelView(order: DeveloperPreview.instance.order)
        }
    }
    .environmentObject(RootViewModel())
}
