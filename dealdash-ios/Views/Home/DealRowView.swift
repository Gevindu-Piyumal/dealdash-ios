//
//  DealRowView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Kingfisher
import SwiftUI

struct DealRowView: View {
    let deal: Deal

    var body: some View {
        HStack(spacing: 12) {
            // Deal image
            KFImage(deal.banner)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 80)
                .cornerRadius(8)

            // Textual info
            VStack(alignment: .leading, spacing: 6) {
                // Vendor name as title
                Text(deal.vendor.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                // Deal description (two lines)
                Text(deal.description)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                // Category on left, “x days ago” on right
                HStack {
                    Text(deal.category.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(deal.createdAt, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Arrow indicator
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct DealRowView_Previews: PreviewProvider {
    static var previews: some View {
        DealRowView(deal: Deal(
            id: "1",
            title: "Kids dine free at Cinnamon Grand",
            description: "This is a sample deal description.",
            banner: URL(string: "https://via.placeholder.com/300")!,
            category: Category(
                id: "1",
                name: "Food & Drink",
                icon: URL(string: "https://via.placeholder.com/100")!
            ),
            startDate: Date(),
            expireDate: Date(),
            isActive: true,
            isFeatured: false,
            vendor: Vendor(
                id: "1",
                name: "Sample Vendor",
                logo: URL(string: "https://via.placeholder.com/50")!,
                address: "123 Sample Street",
                openingHours: "9 AM - 9 PM",
                contactNumber: "+1234567890",
                email: "vendor@example.com",
                website: URL(string: "https://example.com")!,
                socialMedia: SocialMedia(
                    facebook: URL(string: "https://facebook.com/samplevendor")!,
                    instagram: URL(string: "https://instagram.com/samplevendor")!,
                    whatsapp: "+1234567890"
                ),
                location: Location(
                    type: "Point",
                    coordinates: [79.8467213, 6.9291757]
                )
            ),
            createdAt: Date()
        ))
    }
}
