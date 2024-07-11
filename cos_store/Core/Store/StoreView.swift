//
//  StoreView.swift
//  cs_platform
//
//  Created by Vlad Sushko on 14/03/2024.
//

import SwiftUI

struct StoreView: View {
    
    @EnvironmentObject private var vm: RootViewModel
    
    @State private var searchText: String = ""
    @State private var showSortPopover: Bool = false
    @State private var showCategorySheet: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ProductsGridView(vm: _vm)
                            .transition(.scale)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            ForEach(RootViewModel.BrandOption.allCases, id: \.self) { brand in
                                Button {
                                    Task {
                                        vm.selectedBrand = brand
                                        try? await vm.brandSelected(brand: brand)
                                    }
                                } label: {
                                    Text(brand.rawValue)
                                }
                            }
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName:"b.square.fill")
                                    .font(.footnote)
                                    .bold()
                                
                                if vm.selectedBrand == nil || vm.selectedBrand == .all {
                                    Text("rand: All")
                                        .font(.caption)
                                } else {
                                    Text(vm.selectedBrand?.rawValue ?? "")
                                        .font(.footnote)
                                }
                            }
                            .frame(width: 120, alignment: .leading)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            ForEach(RootViewModel.CategoryOption.allCases, id: \.self) { category in
                                Button {
                                    Task {
                                        vm.selectedCategory = category
                                        try? await vm.categorySelected(category: category)
                                    }
                                } label: {
                                    Text(category.rawValue)
                                        .font(.caption)
                                }
                            }
                        } label: {
                            HStack {
                                Text("Category: \(vm.selectedCategory?.rawValue ?? "All")")
                                    .font(.footnote)
                                
                                Image(systemName: "rectangle.on.rectangle.square.fill")
                                    .font(.footnote)
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            ForEach(RootViewModel.SortOption.allCases, id: \.self) { option in
                                Button {
                                    Task {
                                        vm.selectedSortOption = option
                                        try? await vm.sortOptionSelected(option: option)
                                    }
                                } label: {
                                    Text(option.rawValue)
                                        .font(.caption)
                                }
                            }
                        } label: {
                            HStack {
                                Text("Sort:")
                                    .font(.footnote)
                                switch vm.selectedSortOption {
                                case .recommended:
                                    Image(systemName:"slider.horizontal.2.square")
                                        .font(.footnote)
                                        .bold()
                                case .priceLowToHigh:
                                    Image(systemName:"arrow.up.forward.square")
                                        .font(.footnote)
                                        .bold()
                                case .priceHighToLow:
                                    Image(systemName:"arrow.down.right.square")
                                        .font(.footnote)
                                        .bold()
                                case .none:
                                    Image(systemName:"slider.horizontal.2.square")
                                        .font(.footnote)
                                        .bold()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    
                }
                .tint(.primary)
            }
            .task {
                vm.getProducts()
            }
            .searchable(text: $vm.searchText, placement: .toolbar, prompt: "Search")
            .alert(errorMessage ?? "Error", isPresented: Binding(value: $errorMessage)) {
                Button(action: {}, label: {
                    Text("OK")
                })
            }
        }
    }
}


#Preview {
    NavigationStack {
        StoreView()
            .environmentObject(RootViewModel())
    }
}
