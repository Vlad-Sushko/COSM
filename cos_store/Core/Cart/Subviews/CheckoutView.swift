//
//  CheckoutView.swift
//  cos_store
//
//  Created by Vlad Sushko on 28/05/2024.
//

import SwiftUI

struct CheckoutView: View {
    
    @EnvironmentObject var vm: RootViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var deliveryInformation: DeliveryInformation? = nil
    @State private var errorMessage: String? = nil
    
    @State private var isOrdedReceived: Bool = false
    @Binding var showConfirmationView: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                deliverySection
                    .padding(.bottom, 20)
                
                Text("PRODUCTS")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    VStack {
                        productsSection
                    }
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("TOTAL TO PAY: ")
                        Text("$ \(vm.cartTotalPrice.asNumberString())")
                            .bold()
                    }
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    sendOrderButton
                }
                .alert(errorMessage ?? "Error", isPresented: Binding(value: $errorMessage)) {
                    Button(action: {}, label: {
                        Text("OK")
                    })
                }
                .onAppear {
                    Task {
                        try await vm.getProductsInCart(userId: vm.userId)
                        await vm.getProductsFromCartPositions()
                        vm.getCartTotalPrice()
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("CHECKOUT")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension CheckoutView {
    private var deliverySection: some View {
        VStack(alignment: .leading) {
            Text("DELIVERY ADDRESS")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading) {
                if deliveryInformation == nil {
                    NavigationLink(destination: AddressView(vm: AddressViewModel(), deliveryInformation: $deliveryInformation)) {
                        addAddressLabel
                    }
                } else {
                    VStack {
                        if let deliveryInfo = deliveryInformation {
                            DeliveryInformationLabelView(deliveryInformation: deliveryInfo)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .topTrailing) {
                        NavigationLink {
                            AddressView(vm: AddressViewModel(), deliveryInformation: $deliveryInformation)
                        } label: {
                            Text("CHANGE")
                                .bold()
                                .padding(8)
                                .background(.whiteBlackBG)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.grayBG)
        .clipShape(.rect(cornerRadius: 10))
    }
    
    private var productsSection: some View {
        ForEach(vm.cartPositions, id: \.self) { cartPosition in
            ProductLabelView(productManager: vm.productManager, productId: cartPosition.productId)
                .overlay(alignment: .trailing) {
                    HStack(spacing: 0) {
                        Text("Qty:")
                        Text("\(cartPosition.count)")
                            .padding()
                    }
                }
        }
    }
    
    private var addAddressLabel: some View {
        Label("ADD ADDRESS", systemImage: "mappin.circle")
            .tint(.whiteBlackBG)
            .bold()
            .padding(10)
            .background(.black)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.top, 4)
    }
    
    private var sendOrderButton: some View {
        Button(action: {
            Task {
                if (deliveryInformation == nil) { errorMessage = "Add delivery address 📦 " } else {
                    do {
                        if let deliveryInformation = deliveryInformation {
                            try await vm.createOrder(userID: vm.userId, paymentMethod: "??", deliveryInformation: deliveryInformation)
                            try await vm.cleanCart()
                        }
                        showConfirmationView = true
                        dismiss()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }, label: {
            Text("SEND ORDER TO COSM")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.green)
                .clipShape(.rect(cornerRadius: 10))
        })
    }
}


#Preview {
    NavigationStack {
        CheckoutView(showConfirmationView: .constant(false))
            .environmentObject(RootViewModel())
    }
}
