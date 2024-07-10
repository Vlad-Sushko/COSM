//
//  Double.swift
//  cos_store
//
//  Created by Vlad Sushko on 17/03/2024.
//

import Foundation

extension Double {
    
    /// Converts a Double into String representation
    /// ```
    /// Convert 1.2345 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Convert Decimals to Whole Numbers
    /// ```
    /// Convert 12.34 to "12"
    /// ```
    func asNumberStringWithoutDecimals() -> String {
        return String(format: "%.0f", self)
    }
    
}
