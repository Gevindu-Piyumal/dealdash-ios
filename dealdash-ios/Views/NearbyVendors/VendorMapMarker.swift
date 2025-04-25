//
//  VendorMapMarker.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import SwiftUI

struct VendorMapMarker: View {
    let vendor: NearbyVendor

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: vendor.logo) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "building.2")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 30, height: 30)
            .clipShape(Circle())
            .background(
                Circle()
                    .fill(.white)
                    .padding(-2)
            )
            .shadow(radius: 2)

            Text(vendor.name)
                .font(.caption2)
                .padding(4)
                .background(.white.opacity(0.9))
                .cornerRadius(4)
                .lineLimit(1)
        }
    }
}
