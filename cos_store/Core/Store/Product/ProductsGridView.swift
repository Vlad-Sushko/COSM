//
//  ProductsGridView.swift
//  cos_store
//
//  Created by Vlad Sushko on 15/03/2024.
//

import SwiftUI

struct ProductsGridView: View {
    
    @EnvironmentObject var vm: RootViewModel
    
    var filteredProducts: [Product] {
        guard !vm.searchText.isEmpty else { return vm.products }
        return vm.products.filter { product in
            product.title!.lowercased().contains(vm.searchText.lowercased()) ||
            product.brand!.lowercased().contains(vm.searchText.lowercased()
            )
        }
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: -8),
        GridItem(.flexible(), spacing: -8)
    ]
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(filteredProducts) { product in
                        NavigationLink(value: product) {
                            ProductRowView(vm: _vm, product: product)
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 10)
                        
                        if product == vm.products.last  {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.top)
                                .opacity(0.01)
                                .onAppear {
                                    vm.getProducts()
                                }
                        }
                        
                    }
                }
                .navigationDestination(for: Product.self) { product in
                    ProductView(product: product, vm: _vm)
                }
            }
        }
        .tint(.accent)
    }
}

#Preview {
    ProductsGridView()
        .environmentObject(RootViewModel())
    
}
