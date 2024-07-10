//
//  DBUser.swift
//  cos_store
//
//  Created by Vlad Sushko on 22/05/2024.
//

import Foundation

struct DBUser: Codable {
    let userId: String
    let email: String?
    var name: String?
    let dateCreated: Date?
    
    enum CodingKeys: String, CodingKey{
        case userId = "user_id"
        case email = "email"
        case name = "name"
        case dateCreated = "date_created"
    }
    
    init(auth: AuthDataResultModel, name: String? = nil) {
        self.userId = auth.uid
        self.email = auth.email
        self.name = name ?? auth.name
        self.dateCreated = Date()
    }
}
