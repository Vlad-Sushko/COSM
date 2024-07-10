//
//  AccountView.swift
//  cos_store
//
//  Created by Vlad Sushko on 24/04/2024.
//

import SwiftUI

struct AccountView: View {
    
    @State var name: String = ""
    @State var surname: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("FIRST NAME")
                .font(.title3)
                .foregroundStyle(.grayBG)
                
            TextField("First name", text: $name)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.bottom, 10)
            
            Text("LAST NAME")
                .font(.title3)
                .foregroundStyle(.grayBG)
            
            TextField("Last name", text: $surname)
                .padding()
                .background(.grayBG)
                .clipShape(.rect(cornerRadius: 10))
            
            Spacer()
        }
    }
}

#Preview {
    AccountView(name: "", surname: "")
        .padding()
}
