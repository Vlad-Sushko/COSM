//
//  AddressViewModel.swift
//  cos_store
//
//  Created by Vlad Sushko on 06/06/2024.
//

import Foundation

class AddressViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var postalCode: String = ""
    @Published var address: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    // Validation
    func isAddressInformationValid() -> Bool {
        if !email.isValidEmail() ||
            !phoneNumber.isValidPhoneNumber() ||
            firstName.isEmpty ||
            lastName.isEmpty ||
            country.isEmpty ||
            city.isEmpty ||
            postalCode.isEmpty ||
            address.isEmpty { 
            return false
        }
        return true
    }
}
