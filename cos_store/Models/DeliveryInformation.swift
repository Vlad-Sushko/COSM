//
//  Address.swift
//  cos_store
//
//  Created by Vlad Sushko on 30/05/2024.
//

import Foundation

struct DeliveryInformation: Codable {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let email: String
    let country: String
    let city: String
    let postalCode: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email = "email"
        case country = "country"
        case city = "city"
        case postalCode = "postal_code"
        case address = "address"
    }
    
    enum Country: String, CaseIterable {
        case ukraine
        case poland
        case germany
    }
    
    init(firstName: String, lastName: String, phoneNumber: String, email: String, country: String, city: String, postalCode: String, address: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.country = country
        self.city = city
        self.postalCode = postalCode
        self.address = address
    }
}

