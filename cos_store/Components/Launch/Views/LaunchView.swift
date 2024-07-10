//
//  LaunchView.swift
//  cos_store
//
//  Created by Vlad Sushko on 12/06/2024.
//

import SwiftUI

struct LaunchView: View {
    
//    @Environment(\.dismiss) var dismiss
    
    @Binding var showLaunchView: Bool
    
    @State var scaleEffect: Bool = true
    private let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    @State private var loops: Int = 0
    
    var body: some View {
        ZStack {
            Color(.whiteBlackBG)
                .ignoresSafeArea()
            
            Image(.logoCosm)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .scaleEffect(scaleEffect ? 1 : 1.5, anchor: .center)
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.bouncy(duration: 1.5)) {
                loops += 1
                scaleEffect.toggle()
            }
            if loops == 2 {
                showLaunchView = false
            }
        })
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                dismiss()
//            }
//        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(false))
}
