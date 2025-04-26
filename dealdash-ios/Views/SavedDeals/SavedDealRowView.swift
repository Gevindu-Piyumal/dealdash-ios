//
//  SavedDealRowView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-26.
//

import Kingfisher
import SwiftUI

struct SavedDealRowView: View {
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
}

struct SavedDealRowView_Previews: PreviewProvider {
    static var previews: some View {
        SavedDealRowView(deal: .sampleDeal)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
