//
//  VendorListSection.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import SwiftUI

struct VendorListSection: View {
    let vendors: [NearbyVendor]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(vendors) { vendor in
                    VendorCard(vendor: vendor)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }
}
