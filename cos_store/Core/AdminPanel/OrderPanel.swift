//
//  AdminPanel.swift
//  cos_store
//
//  Created by Vlad Sushko on 07/05/2024.
//

import SwiftUI

struct OrderPanel: View {
    
    @StateObject private var vm: OrderPanelViewModel
    
    @State private var selectedStatus: OrderPanelViewModel.StatusOption? = nil
    
    let statuses: [OrderPanelViewModel.StatusOption] = [.orderCreated, .waitingForPayment, .paymantAccepted, .shipped]
    let statuses2: [OrderPanelViewModel.StatusOption] = [.allStatuses, .delivered, .canceled, .refunded]
    
    @Namespace private var namespace
    
    init(vm: OrderPanelViewModel) {
        _vm = StateObject(wrappedValue: OrderPanelViewModel(storageManager: StorageManager(), productManager: ProductManager(), orderManager: OrderManager()))
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    ForEach(statuses2, id: \.self) { status in
                        ZStack {
                            if selectedStatus == status {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.pink.opacity(0.3))
                                    .matchedGeometryEffect(id: "status_background", in: namespace)
                            }
                            Text(status.rawValue)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .onTapGesture {
                            withAnimation(.spring) {
                                selectedStatus = status
                            }
                        }
                    }
                    .onChange(of: selectedStatus) { _, _ in
                        Task {
                            if let selectedStatus {
                                try await vm.statusSelected(status: OrderPanelViewModel.StatusOption(rawValue: selectedStatus.rawValue) ?? .allStatuses)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    ForEach(statuses, id: \.self) { status in
                        ZStack {
                            if selectedStatus == status {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.pink.opacity(0.3))
                                    .matchedGeometryEffect(id: "status_background", in: namespace)
                            }
                            
                            Text(status.rawValue)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .onTapGesture {
                            withAnimation(.spring) {
                                selectedStatus = status
                            }
                        }
                    }
                    .onChange(of: selectedStatus) { _, _ in
                        Task {
                            if let selectedStatus {
                                try await vm.statusSelected(status: OrderPanelViewModel.StatusOption(rawValue: selectedStatus.rawValue) ?? .allStatuses)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
            }
            .background()
            .shadow(radius: 4)
            
            ScrollView {
                VStack {
                    
                    ForEach($vm.allOrders) { $order in
                        VStack {
                            AdminOrderLabelView(vm: vm, order: $order)
                                .padding(.vertical, 6)
                        }
                    }
                }
                .onFirstAppear {
                    vm.addListenerForOrders()
                }
                .padding(.vertical)
            }
        }
        .refreshable {
            Task {
                vm.getAllOrders
            }
        }
    }
}

#Preview {
    NavigationStack {
        OrderPanel(vm: OrderPanelViewModel(storageManager: StorageManager(),
                                           productManager: ProductManager(),
                                           orderManager: OrderManager()))
    }
}

