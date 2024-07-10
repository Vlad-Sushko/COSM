//
//  AdminPanel.swift
//  cos_store
//
//  Created by Vlad Sushko on 19/06/2024.
//

import SwiftUI

struct AdminPanel: View {
    
    var body: some View {
        VStack {
            Divider()
            
            NavigationLink(destination: OrderPanel(vm: OrderPanelViewModel(
                storageManager: StorageManager(),
                productManager: ProductManager(),
                orderManager: OrderManager()))) {
                    ordersManagerLabel
                }
            Divider()
            
            NavigationLink(destination: ProductsPanel()) {
                productsManagerLabel
            }
            Divider()
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Admin Panel")
    }
}

extension AdminPanel {
    private var ordersManagerLabel: some View {
        HStack {
            Image(systemName: "tray.full")
                .frame(width: 35)
            Text("Orders Management")
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .padding(.vertical, 10)
    }
    
    private var productsManagerLabel: some View {
        HStack {
            Image(systemName: "archivebox")
                .frame(width: 35)
            Text("Products Management")
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    NavigationStack {
        AdminPanel()
    }
}
