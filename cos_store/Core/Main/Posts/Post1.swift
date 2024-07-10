//
//  Post1.swift
//  cos_store
//
//  Created by Vlad Sushko on 27/06/2024.
//

import SwiftUI

struct Post1: View {
    
    @EnvironmentObject private var vm: RootViewModel
    
    @State var product: Product? = nil
    let productId: String = DeveloperPreview.instance.productId
    
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            ZStack {
                Image(.post1)
                    .resizable()
                    .scaledToFill()
                
                if let product {
                    NavigationLink {
                        ProductView(product: product)
                            .environmentObject(RootViewModel())
                    } label: {
                        Text("DISCOVER NOW")
                            .font(.caption2)
                            .bold()
                            .foregroundStyle(.black)
                            .padding(10)
                            .background(.white.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 10))
                    }
                    .offset(y: 90)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .onAppear {
            Task {
                self.product = try await vm.productManager.getProduct(productID: productId)
            }
        }
    }
}

#Preview {
    NavigationStack {
        Post1(selectedTab: .constant(0))
            .environmentObject(RootViewModel())
    }
}
