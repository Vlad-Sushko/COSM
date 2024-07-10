//
//  AdminPanel.swift
//  cos_store
//
//  Created by Vlad Sushko on 06/05/2024.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    @StateObject private var vm: ProductsPanelViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var imageData: Data? = nil
    @State private var errorMessage: String? = nil
    @State var showSuccessView: Bool = false
    @State var showSuccessAnimation: Bool = false
    
    @State var title: String = ""
    @State var brand: RootViewModel.BrandOption.RawValue = ""
    @State var category: RootViewModel.CategoryOption.RawValue = ""
    @State var description: String = ""
    @State var price: Double = 00.00
    @State var weight: String = ""
    @State var ingridients: String = ""
    @State var manufacturer: String = ""
    
    
    init(vm: ProductsPanelViewModel) {
        _vm = StateObject(wrappedValue: ProductsPanelViewModel(storageManager: StorageManager(), productManager: ProductManager()))
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    imageSection
                    
                    titleSection
                    Divider()
                    
                    brandSection
                    Divider()
                    
                    categorySection
                    Divider()
                    
                    descriptionSection
                    Divider()
                    
                    priceSection
                    Divider()
                    
                    weightSection
                    Divider()
                    
                    ingridientsSection
                    Divider()
                    
                    manufacturerSection
                    
                    addProductButton
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal)
            .navigationTitle("Add Product")
            .alert(errorMessage ?? "Error", isPresented: Binding(value: $errorMessage)) {
                Button(action: {}, label: {
                    Text("OK")
                })
            }
            successView
        }
    }
}


extension AddProductView {
    
    private var successView: some View {
        VStack {
            if showSuccessView {
                HStack {
                    Text("Product successfully added ")
                        .font(.headline)
                        .onAppear {
                            withAnimation(.linear(duration: 1.5)) {
                                showSuccessAnimation = true
                            }
                        }
                    
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title)
                        
                        if showSuccessAnimation {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .foregroundStyle(.green)
                .padding(30)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 15))
                .shadow(radius: 30)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var titleSection: some View {
        HStack {
            Text("TITLE:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            
            TextField("Title:", text: $title, axis: .vertical)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    private var imageSection: some View {
        VStack(spacing: 10) {
            Divider()
            
            Text("ADD PHOTOS")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            
            ScrollView(.horizontal) {
                
                HStack {
                    VStack(spacing: 4) {
                        if vm.imageSelection == nil {
                            PhotosPicker(selection: $vm.imageSelection, photoLibrary: .shared()) {
                                Image(systemName: "plus")
                                    .fontWeight(.light)
                                    .font(.system(size: 22))
                                    .frame(maxWidth: 140, alignment: .center)
                                    .frame(width: 140, height: 140)
                                    .border(Color.secondary, width: 1)
                            }
                            .tint(.secondary)
                        }
                        
                        if vm.imageSelection != nil, let image = vm.productImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 140, height: 140)
                                .overlay(alignment: .topTrailing) {
                                    Button(action: {
                                        vm.imageSelection = nil
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .bold()
                                            .foregroundStyle(.white)
                                    })
                                    .padding(4)
                                    .background(.red)
                                    .padding(8)
                                }
                        }
                        Text("main photo")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom)
            }
            Divider()
        }
    }
}

extension AddProductView {    
    private var brandSection: some View {
        HStack {
            Text("Brand:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            
            Picker("Select a brand", selection: $brand) {
                Text("...").tag("")
                ForEach(RootViewModel.BrandOption.allCases, id: \.rawValue) { brand in
                    Text(brand.rawValue).tag(brand.rawValue)
                }
            }
            .tint(.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var categorySection: some View {
        HStack {
            Text("Category:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            
            Picker("Select a category", selection: $category) {
                Text("...").tag("")
                ForEach(RootViewModel.CategoryOption.allCases, id: \.rawValue) { category in
                    Text(category.rawValue).tag(category.rawValue)
                }
            }
            .tint(.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var descriptionSection: some View {
        HStack {
            Text("Description:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            
            TextField("Description", text: $description, axis: .vertical)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    private var priceSection: some View {
        HStack {
            Text("$ Price:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            
            TextField("00.00", value: $price, format: .currency(code: "$"))
                .keyboardType(.decimalPad)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    private var weightSection: some View {
        HStack {
            Text("Weight:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            
            TextField("e.g 100g.", text: $weight)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    private var ingridientsSection: some View {
        HStack {
            Text("Ingridients:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            
            TextField("Ingridients", text: $ingridients, axis: .vertical)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    private var manufacturerSection: some View {
        HStack {
            Text("Manufacturer:")
                .foregroundStyle(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            
            TextField("Manufacturer..", text: $manufacturer, axis: .vertical)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    private var addProductButton: some View {
        Button(action: {
            Task {
                do {
                    try await vm.addProduct(product:
                                                Product(id: vm.product.id,
                                                        title: title,
                                                        brand: brand,
                                                        category: category,
                                                        price: price,
                                                        description: description,
                                                        weight: weight,
                                                        manufacturer: manufacturer,
                                                        ingridients: ingridients,
                                                        image: vm.product.image,
                                                        imagePath: vm.product.imagePath))
                    
                    if let selectedImage = vm.imageSelection {
                        vm.saveProductImage(item: selectedImage, productId: vm.product.id)
                    } else  {
                        errorMessage = "Selected image could not be saved"
                    }
                    showSuccessView = true
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }, label: {
            Text("Add Product")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        })
        .padding(.top, 10)
    }
}

#Preview {
    NavigationStack {
        AddProductView(vm: ProductsPanelViewModel(storageManager: StorageManager(),
                                                  productManager: ProductManager()))
    }
}
