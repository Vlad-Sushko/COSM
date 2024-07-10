//
//  View.swift
//  cos_store
//
//  Created by Vlad Sushko on 28/05/2024.
//

import Foundation
import SwiftUI

extension View {
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(perform: perform))
    }
}
