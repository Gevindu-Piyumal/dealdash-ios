//
//  SavedDealsView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-26.
//

import Kingfisher
import SwiftUI

struct SavedDealsView: View {
    @StateObject private var viewModel = SavedDealsViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.savedDeals) { deal in
                    NavigationLink(destination: DealDetailView(dealId: deal.id)) {
                        // Use custom row without NavigationLink
                        CustomDealRowContent(deal: deal)
                    }
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: viewModel.deleteSavedDeal)
            }
            .listStyle(.plain)
            .navigationTitle("Saved Deals")
            .onAppear {
                viewModel.loadSavedDeals()
            }
            .refreshable {
                viewModel.loadSavedDeals()
            }
        }
        .environment(\.defaultMinListRowHeight, 10)
    }
}

struct CustomDealRowContent: View {
    let deal: Deal
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage(deal.banner)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(deal.vendor.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(deal.title)
                    .font(.subheadline)
                    .lineLimit(2)
                
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
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // Copy of the formattedTimeAgo function
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

extension DateFormatter {
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
