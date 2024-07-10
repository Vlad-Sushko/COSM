//
//  DeliveryInformationLabelView.swift
//  cos_store
//
//  Created by Vlad Sushko on 20/06/2024.
//

import SwiftUI

struct DeliveryInformationLabelView: View {
    
    let deliveryInformation: DeliveryInformation
    
    init(deliveryInformation: DeliveryInformation) {
        self.deliveryInformation = deliveryInformation
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle")
                Text(deliveryInformation.firstName)
                Text(deliveryInformation.lastName)
            }
            HStack {
                Image(systemName: "flag.circle")
                Text("\(deliveryInformation.country),")
                Text(deliveryInformation.city)
            }
            HStack {
                Image(systemName: "house.circle")
                Text(deliveryInformation.address)
            }
            HStack {
                Image(systemName: "signpost.right.circle")
                Text(deliveryInformation.postalCode)
            }
            HStack {
                Image(systemName: "phone.circle")
                Text(deliveryInformation.phoneNumber)
            }
            HStack {
                Image(systemName: "envelope.circle")
                Text(deliveryInformation.email)
            }
        }
    }
}

#Preview {
    DeliveryInformationLabelView(deliveryInformation: DeveloperPreview.instance.order.deliveryInformation!)
}
