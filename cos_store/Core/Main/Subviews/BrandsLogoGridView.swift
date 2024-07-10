//
//  BrandsLogoGridView.swift
//  cos_store
//
//  Created by Vlad Sushko on 21/03/2024.
//

import SwiftUI

struct BrandsLogoGridView: View {
    
    @Binding var selectedTab: Int
    
    private let allBrands: [(brand: RootViewModel.BrandOption, imageName: String)] = [
        (brand: .needly, imageName: "needlyLogo"),
        (brand: .drCeuracle, imageName: "drCeuracleLogo"),
        (brand: .atache, imageName: "atacheLogo"),
        (brand: .theramid, imageName: "theramidLogo"),
        (brand: .roundLab, imageName: "roundLabLogo"),
        (brand: .cuSkin, imageName: "cuskinLogo")
    ]
    
    @Binding var selectedBrand: RootViewModel.BrandOption
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: -8),
        GridItem(.flexible(), spacing: -8),
        GridItem(.flexible(), spacing: -8)
    ]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(allBrands, id: \.brand) { brand in
                        Button(action: {
                            selectedTab = 1
                            selectedBrand = brand.brand
                        }, label: {
                            Image(brand.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .clipShape(.rect(cornerRadius: 15))
                                .padding()
                                .shadow(radius: 10)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    BrandsLogoGridView(selectedTab: .constant(0), selectedBrand: .constant(.needly))
}
