//
//  VendorCard.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import Kingfisher
import SwiftUI

struct VendorCard: View {
    let vendor: NearbyVendor

    var body: some View {
        NavigationLink(destination: VendorDetailView(vendor: vendor.toVendor()))
        {
            HStack {
                KFImage(vendor.logo)
                    .resizable()
                    .placeholder {
                        ZStack {
                            Color(UIColor.systemGray6)
                            Image(systemName: "building.2")
                                .foregroundColor(.gray)
                        }
                    }
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text(vendor.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(vendor.activeDealCount) Deals")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("\(Int((vendor.distance + 500) / 1000))km away")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
