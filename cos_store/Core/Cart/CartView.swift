//
//  CartView.swift
//  cos_store
//
//  Created by Vlad Sushko on 17/03/2024.
//

import SwiftUI

struct CartView: View {
    
    @EnvironmentObject private var vm: RootViewModel
    @Binding var selectedTab: Int
    @State var showConfirmationView: Bool = false
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(vm.cartPositions, id: \.self) { cartPosition in
                            CartPositionView(cartPosition: cartPosition)
                        }
                    }
                }
                .navigationTitle("Cart")
                .padding(.horizontal)
                
                VStack {
                    totalSection
                    
                    Button(action: {
                        selectedTab = 1
                    }, label: {
                        continueShoppingButton
                    })
                    
                    if vm.cartPositions.count >= 1 {
                        NavigationLink {
                            CheckoutView(showConfirmationView: $showConfirmationView)
                        } label: {
                            checkoutButton
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 10)
            }
            .padding(.bottom, 12)
            .onAppear {
                Task {
                    try await vm.getProductsInCart(userId: vm.userId)
                    await vm.getProductsFromCartPositions()
                    vm.getCartTotalPrice()
                }
            }
            .onFirstAppear {
                vm.addListenerForCartPositions()
            }
            .fullScreenCover(isPresented: $showConfirmationView, content: {
                OrderConfirmationView()
            })
        }
    }
}

extension CartView {
    private var totalSection: some View {
        HStack {
            Text("Total Amount:")
                .foregroundStyle(.secondary)
            Spacer()
            Text("$\(vm.cartTotalPrice.asNumberString())")
                .bold()
        }
        .padding()
    }
    
    private var checkoutButton: some View {
        Text("CHECKOUT")
            .foregroundStyle(.white)
            .font(.headline)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(.green)
            .clipShape(.rect(cornerRadius: 15))
    }
    
    private var continueShoppingButton: some View {
        Text("Continue shopping")
            .foregroundStyle(.white)
            .font(.headline)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(.orange)
            .clipShape(.rect(cornerRadius: 15))
    }
}

#Preview {
    NavigationStack {
        CartView(selectedTab: .constant(2))
            .environmentObject(RootViewModel())
    }
}


