//
//  AddressView.swift
//  cos_store
//
//  Created by Vlad Sushko on 30/05/2024.
//

import SwiftUI

struct AddressView: View {
    
    @StateObject var vm: AddressViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var errorMessage: String? = nil
    
    init(vm: AddressViewModel, deliveryInformation: Binding<DeliveryInformation?>){
        _vm = StateObject(wrappedValue: AddressViewModel())
        self._deliveryInformation = deliveryInformation
    }
    
    @Binding var deliveryInformation: DeliveryInformation?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                //TODO: ADD TEXT VALIDATION
                //TODO: ADD COUNTRY SELECTOR ENUM
                
                Text("FIRST NAME")
                    .foregroundStyle(vm.firstName.isEmpty ? .textAdaptive : .green)
                    .font(.subheadline)
                
                TextField("First name..", text: $vm.firstName)
                    .padding()
                    .background(.grayBG)
                    .clipShape(.rect(cornerRadius: 10))
                
                Text("LAST NAME")
                    .foregroundStyle(vm.lastName.isEmpty ? .textAdaptive : .green)
                    .font(.subheadline)
                
                TextField("Last name..", text: $vm.lastName)
                    .padding()
                    .background(.grayBG)
                    .clipShape(.rect(cornerRadius: 10))
                
                
                Text("EMAIL")
                    .font(.subheadline)
                    .foregroundStyle(vm.email.isValidEmail() ? .green : .textAdaptive)
                
                TextField("Email", text: $vm.email)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.grayBG)
                    .clipShape(.rect(cornerRadius: 10))
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("PHONE NUMBER")
                            .font(.subheadline)
                            .foregroundStyle(vm.phoneNumber.isValidPhoneNumber() ? .green : .textAdaptive)
                        
                        TextField("Phone number", text: $vm.phoneNumber)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(.grayBG)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("POSTAL CODE")
                            .foregroundStyle(vm.postalCode.isEmpty ? .textAdaptive : .green)
                            .font(.subheadline)
                        
                        TextField("Postal Code", text: $vm.postalCode)
                            .padding()
                            .background(.grayBG)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("COUNTRY")
                            .foregroundStyle(vm.country.isEmpty ? .textAdaptive : .green)
                            .font(.subheadline)
                        
                        TextField("Country", text: $vm.country)
                            .padding()
                            .background(.grayBG)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("CITY")
                            .foregroundStyle(vm.city.isEmpty ? .textAdaptive : .green)
                            .font(.subheadline)
                        
                        TextField("City", text: $vm.city)
                            .padding()
                            .background(.grayBG)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                }
                Text("ADDRESS")
                    .foregroundStyle(vm.address.isEmpty ? .textAdaptive : .green)
                    .font(.subheadline)
                
                TextField("Address", text: $vm.address)
                    .padding()
                    .background(.grayBG)
                    .clipShape(.rect(cornerRadius: 10))
                
                Button(action: {
                    deliveryInformation = DeliveryInformation(firstName: vm.firstName, lastName: vm.lastName, phoneNumber: vm.phoneNumber, email: vm.email, country: vm.country, city: vm.city, postalCode: vm.postalCode, address: vm.address)
                    dismiss()
                }, label: {
                    Text("SAVE")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(vm.isAddressInformationValid() ? .green : .gray)
                        .clipShape(.rect(cornerRadius: 15))
                })
                .disabled(!vm.isAddressInformationValid())
                .padding(.top, 18)
            }
            .disableAutocorrection(true)
            .padding()
            .autocorrectionDisabled()
        }
        .navigationTitle("DELIVERY ADDRESS")
        .alert(errorMessage ?? "Error", isPresented: Binding(value: $errorMessage)) {
            Button(action: {}, label: {
                Text("OK")
            })
        }
    }
}

#Preview {
    NavigationStack {
        AddressView(vm: AddressViewModel(), deliveryInformation: .constant(
            DeliveryInformation(firstName: "",
                                lastName: "",
                                phoneNumber: "",
                                email: "",
                                country: "",
                                city: "",
                                postalCode: "",
                                address: "")))
    }
}
