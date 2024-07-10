//
//  OrderConfirmationView.swift
//  cos_store
//
//  Created by Vlad Sushko on 07/06/2024.
//

import SwiftUI

struct OrderConfirmationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.thickMaterial)
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Image(.logoCosm)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.pink)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                Text("Thank you for order, your products will be shipped soon!")
                Text("You can track the order from orders list.")
                    .foregroundStyle(.secondary)
            }
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .bold()
                })
                
            }
            .padding()
            .background(.whiteBlackBG)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 10)
            .padding()
        }
        .ignoresSafeArea(.all)
        
    }
}

#Preview {
    OrderConfirmationView()
}
