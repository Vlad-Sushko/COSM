//
//  ProductsPanel.swift
//  cos_store
//
//  Created by Vlad Sushko on 19/06/2024.
//

import SwiftUI

struct ProductsPanel: View {
    var body: some View {
        VStack {
            Divider()
            
            NavigationLink {
                AddProductView(vm: ProductsPanelViewModel(storageManager: StorageManager(), productManager: ProductManager()))
            } label: {
                addProductLabel
            }
            Divider()
            
            Spacer()
        }
        .navigationTitle("Products Panel")
    }
}

extension ProductsPanel {
    private var addProductLabel: some View {
        HStack {
            Image(systemName: "person.crop.rectangle.stack.fill")
                .frame(width: 35)
            Text("Add Product")
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .padding(10)
    }
}

#Preview {
    NavigationStack {
        ProductsPanel()
    }
}
