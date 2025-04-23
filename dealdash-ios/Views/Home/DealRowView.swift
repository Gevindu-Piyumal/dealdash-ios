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
            KFImage(deal.banner)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 6) {
                Text(deal.vendor.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(deal.title)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .frame(height: 36, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)

                HStack {
                    Text(deal.category.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(formattedTimeAgo(from: deal.createdAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

private func formattedTimeAgo(from date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()

    if calendar.isDateInToday(date) {
        return "Today"
    }

    let components = calendar.dateComponents([.day], from: date, to: now)
    if let days = components.day, days > 0 {
        return "\(days) \(days == 1 ? "day" : "days") ago"
    }

    return "Today"
}

struct DealRowView_Previews: PreviewProvider {
    static var previews: some View {
        DealRowView(deal: .sampleDeal)
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Hardcoded Preview")

        DealFromAPIPreview()
            .previewDisplayName("API Preview")
    }
}

extension Deal {
    static var sampleDeal: Deal {
        Deal(
            id: "sample1",
            title: "Kids dine free on weekends",
            description: "Sample deal description here",
            banner: URL(
                string:
                    "https://exgljghcbqshcrapeczd.supabase.co/storage/v1/object/public/deal-images/1745329494124-34792b178d2416bd.jpg"
            )!,
            category: Category(
                id: "cat1",
                name: "Food & Drink",
                icon: URL(string: "https://via.placeholder.com/32")!
            ),
            startDate: Date(),
            expireDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
            isActive: true,
            isFeatured: true,
            vendor: Vendor(
                id: "v1",
                name: "Cinnamon Grand Colombo",
                logo: URL(string: "https://via.placeholder.com/100")!,
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
            ),
            createdAt: Date().addingTimeInterval(-60 * 60 * 24 * 3)
        )
    }
}

struct DealFromAPIPreview: View {
    @State private var deal: Deal?

    var body: some View {
        Group {
            if let deal = deal {
                DealRowView(deal: deal)
            } else {
                ProgressView("Loading...")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .onAppear {
            Task {
                do {
                    let deals = try await APIService.shared.fetchDeals()
                    if let firstDeal = deals.first {
                        await MainActor.run {
                            self.deal = firstDeal
                        }
                    }
                } catch {}
            }
        }
    }
}
