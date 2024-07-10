//
//  OrdersView.swift
//  cos_store
//
//  Created by Vlad Sushko on 07/06/2024.
//

import SwiftUI

struct OrdersView: View {
    
    let orders: [Order]
    
    init(orders: [Order]) {
        self.orders = orders.sorted(by: {$0.dateCreated > $1.dateCreated})
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(orders, id: \.id) { order in
                    OrderLabelView(order: order)
                }
            }
        }
        .navigationTitle("Orders")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        OrdersView(orders: DeveloperPreview.instance.orders)
            .environmentObject(RootViewModel())
    }
}
