//
//  ErrorManager.swift
//  cos_store
//
//  Created by Vlad Sushko on 08/07/2024.
//

import Foundation

enum GeneralError: Error, LocalizedError {
    case noInternetConnection
    case unableDatabase
    case dataNotFound
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            "Please check your internet connection and try again."
        case .unableDatabase:
            "Unable to connect to DB please try later."
        case .dataNotFound:
            "There was an error loading data. Please try again!"
        }
    }
}

