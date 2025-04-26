//
//  SavedDealsView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-26.
//

import SwiftUI

struct SavedDealsView: View {
    @StateObject private var viewModel = SavedDealsViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.savedDeals) { deal in
                    dealRow(for: deal)
                }
                .onDelete(perform: viewModel.deleteSavedDeal)
            }
            .listStyle(.plain)
            .navigationTitle("Saved Deals")
            .onAppear { viewModel.loadSavedDeals() }
            .refreshable { viewModel.loadSavedDeals() }
        }
    }

    @ViewBuilder
    private func dealRow(for deal: Deal) -> some View {
        SavedDealRowView(deal: deal)
            .contentShape(Rectangle())
            .overlay {
                NavigationLink("", destination: DealDetailView(dealId: deal.id))
                    .buttonStyle(.plain)
                    .opacity(0)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button {
                    viewModel.deleteSaved(deal: deal)
                } label: {
                    Label("", systemImage: "bookmark.slash")
                }
                .tint(.orange)
            }
            .listRowInsets(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
            .listRowSeparator(.hidden)
    }
}

extension SavedDealsViewModel {
    func deleteSaved(deal: Deal) {
        if let idx = savedDeals.firstIndex(where: { $0.id == deal.id }) {
            deleteSavedDeal(at: IndexSet(integer: idx))
        }
    }
}
