//
//  MainView.swift
//  cos_store
//
//  Created by Vlad Sushko on 18/03/2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var vm: RootViewModel
    
    @State var selectedBrand: RootViewModel.BrandOption = .all
    @State var selectedCategory: RootViewModel.CategoryOption = .All
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack() {
                    ScrollView {
                        logoSection
                        postSection
                        
                        shopNowButton
                        
                        Text("Well known all over the world for their superior quality")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        Divider()
                        
                        BrandsLogoGridView(selectedTab: $selectedTab, selectedBrand: $selectedBrand)
                        
                        Divider()
                        
                        Spacer()
                        
                        articlesSection
                    }
                }
            }
        }
        .onChange(of: selectedBrand) { _, newValue in
            vm.selectedBrand = newValue
            Task {
                try? await vm.brandSelected(brand: newValue)
            }
        }
        .onChange(of: selectedCategory) { _, newValue in
            vm.selectedCategory = newValue
            Task {
                try? await vm.categorySelected(category: newValue)
            }
        }
    }
}

extension MainView {
    
    private var logoSection: some View {
        Image(.logoCOSM)
            .resizable()
            .scaledToFit()
            .frame(height: 30)
            .padding(6)
    }
    
    private var postSection: some View {
        TabView {
            Post1(selectedTab: $selectedTab)
        }
        .frame(height: 280)
        .tabViewStyle(.page)
    }
    
    private var shopNowButton: some View {
        Button(action: {
            selectedTab = 1
        }, label: {
            Text("SHOP NOW")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
        })
        .padding()
    }
    
    private var productsScrollSection: some View {
        ScrollView {
            ForEach(1..<8) { _ in
                Image(.roundlab)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 150)
                    .clipShape(.rect(cornerRadius: 15))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.trailing)
        .padding(.vertical)
        .scrollIndicators(.hidden)
    }
    
    private var articlesSection: some View {
        VStack(alignment: .leading) {
            Text("Articles for you")
                .font(.headline)
                .padding(.leading, 17)
                .offset(y: 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(1..<3) { _ in
                        ArticleView()
                            .padding(18)
                            .frame(width: 350)
                    }
                }
            }
            .padding(.bottom, 10)
        }
    }
}


#Preview {
    NavigationStack {
        MainView(selectedTab: .constant(1))
            .environmentObject(RootViewModel())
    }
}
