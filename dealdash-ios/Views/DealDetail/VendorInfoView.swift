//
//  VendorInfoView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-24.
//

//
//  VendorInfoView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-24.
//

import Kingfisher
import SwiftUI

struct VendorInfoView: View {
    let vendor: Vendor

    var body: some View {
        HStack(spacing: 12) {
            KFImage(vendor.logo)
                .resizable()
                .placeholder {
                    ZStack {
                        Color(UIColor.systemGray6)
                        ProgressView()
                    }
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(vendor.name)
                    .font(.headline)

                if let openingHours = vendor.openingHours {
                    Text(openingHours)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if let contactNumber = vendor.contactNumber {
                    Text(contactNumber)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if vendor.contactNumber != nil {
                Button(action: {
                    if let phoneNumber = vendor.contactNumber,
                        let url = URL(
                            string:
                                "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))"
                        )
                    {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "phone.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}

struct VendorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VendorInfoView(
            vendor: Vendor(
                id: "v1",
                name: "Cinnamon Grand Colombo",
                logo: URL(
                    string:
                        "https://exgljghcbqshcrapeczd.supabase.co/storage/v1/object/public/vendor-logos/1745327921426-4ff525067b5408c5.png"
                )!,
                address: "123 Main St",
                openingHours: "9am-5pm",
                contactNumber: "1234567890",
                email: "example@example.com",
                website: URL(string: "https://example.com")!,
                socialMedia: SocialMedia(
                    facebook: URL(string: "https://facebook.com")!,
                    instagram: URL(string: "https://instagram.com")!,
                    whatsapp: "1234567890"
                ),
                location: Location(type: "Point", coordinates: [0.0, 0.0])
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
