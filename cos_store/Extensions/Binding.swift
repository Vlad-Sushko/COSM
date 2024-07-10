//
//  Binding.swift
//  cos_store
//
//  Created by Vlad Sushko on 06/05/2024.
//

import SwiftUI

extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy { source.wrappedValue = nil }
                else { source.wrappedValue = newValue }
            }
        )
    }
}

extension Binding where Value == Bool {
    init<T>(value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}
