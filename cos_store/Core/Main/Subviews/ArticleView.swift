//
//  ArticleView.swift
//  cos_store
//
//  Created by Vlad Sushko on 20/03/2024.
//

import SwiftUI

struct ArticleView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(.article1)
                .resizable()
                .frame(height: 120)
            
            VStack(alignment: .leading) {
                Text("TOP 10 Skincare trands in 2024!")
                    .font(.subheadline)
                    .bold()
                
                Text("Products guide by COSM")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 10)
            .padding(.bottom, 6)
        }
        .background()
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 10)
    }
}

#Preview {
    ArticleView()
        .padding()
}
