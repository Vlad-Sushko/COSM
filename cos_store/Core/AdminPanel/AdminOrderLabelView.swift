//
//  AdminOrderLabelView.swift
//  cos_store
//
//  Created by Vlad Sushko on 18/06/2024.
//


import SwiftUI

struct AdminOrderLabelView: View {
    
    @StateObject private var vm: OrderPanelViewModel
    
    @State private var product: Product? = nil
    @State private var showDetails: Bool = false
    @State private var orderStatus: String = Order.OrderStatus.canceled.rawValue
    
    @State private var errorMessage: String? = nil
    @State private var showConfirmationDialog: Bool = false
    
    @Binding var order: Order
    
    init(vm: OrderPanelViewModel, order: Binding<Order>) {
        _vm = StateObject(wrappedValue: OrderPanelViewModel(storageManager: StorageManager(), productManager: ProductManager(), orderManager: OrderManager()))
        self._order = order
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                changeStatusButton
                statusSelector
            }
            
            VStack {
                HStack {
                    orderLabel
                    
                    VStack(alignment: .leading) {
                        
                        Text("# \(order.id)")
                            .font(.caption)
                            .textSelection(.enabled)
                        
                        statusSection
                        
                        HStack {
                            Text(order.dateCreated.formatted(date: .abbreviated, time: .shortened))
                            Spacer()
                            Text("\(order.total?.asNumberString() ?? "")$")
                        }
                    }
                }
                .padding(.bottom, 6)
            }
            .padding(.horizontal)
            .onTapGesture {
                showDetails.toggle()
            }
            .confirmationDialog("Confirm the order status change from \(order.status ?? "unknown") to \(orderStatus)?",
                                isPresented: $showConfirmationDialog,
                                titleVisibility: .visible) {
                Group {
                    Button("YES", role: .destructive) {
                        Task {
                            do {
                                try await vm.changeOrderStatus(orderId: order.id, userId: order.userId, status: orderStatus)
                                self.order = try await vm.getOrder(orderId: order.id)
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    Button("NO", role: .cancel) {}
                }
            }
            if showDetails {
                detailsView
            }
        }
        .background()
        .clipShape(.rect(cornerRadius: 10))
        .shadow(radius: 5)
        .padding(.horizontal)
        .onAppear {
            Task {
                orderStatus = order.status ?? Order.OrderStatus.canceled.rawValue
                if let productId = order.positions?.first?.id {
                    self.product = try await vm.productManager.getProduct(productID: productId)
                }
            }
        }
    }
    
    private var changeStatusButton: some View {
        Button(action: {
            Task {
                showConfirmationDialog = true
            }
        }, label: {
            Label("Change Status", systemImage: "arrow.clockwise.circle")
                .foregroundStyle(.white)
                .bold()
                .padding(.leading, 5)
                .frame(height: 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.green)
        })
    }
    
    private var statusSelector: some View {
        Picker("Picker Name", selection: $orderStatus) {
            ForEach(Order.OrderStatus.allCases) { status in
                Text(status.rawValue).tag(status.rawValue)
                    .bold()
            }
        }
        .padding(.top, 4)
        .pickerStyle(.automatic)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var orderLabel: some View {
        VStack {
            if let product = product {
                ProductImageView(product: product, storageManager: vm.storageManager, imageSize: .medium)
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
    
    private var statusSection: some View {
        HStack {
            Text("Status: ")
            if order.status == Order.OrderStatus.orderCreated.rawValue {
                Text(order.status ?? "Unknown status")
                    .foregroundStyle(.blue)
            } else {
                Text(order.status ?? "Unknown status")
                    .foregroundStyle(order.status == Order.OrderStatus.canceled.rawValue || order.status == Order.OrderStatus.refunded.rawValue ? .red : .green)
            }
        }
    }
    
    private var detailsView: some View {
        VStack(alignment: .leading) {
            Divider()
            if let positions = order.positions {
                ForEach(positions, id: \.self) { position in
                    ProductLabelView(productManager: vm.productManager, productId: position.productId)
                        .overlay(alignment: .bottomTrailing) {
                            Text("Qty: \(position.count)")
                                .padding(.bottom, 8)
                        }
                }
            }
            Text("Delivery Information")
                .font(.caption)
            
            Divider()
            
            if let deliveryInfo = order.deliveryInformation {
                DeliveryInformationLabelView(deliveryInformation: deliveryInfo)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 4)
        .transition(.move(edge: .top))
    }
}

#Preview {
    ScrollView {
        Group {
            AdminOrderLabelView(vm: OrderPanelViewModel(
                storageManager: StorageManager(),
                productManager: ProductManager(),
                orderManager: OrderManager()),
                                order: .constant(DeveloperPreview.instance.order))
            AdminOrderLabelView(vm: OrderPanelViewModel(
                storageManager: StorageManager(),
                productManager: ProductManager(),
                orderManager: OrderManager()),
                                order: .constant(DeveloperPreview.instance.order))
        }
    }
}
