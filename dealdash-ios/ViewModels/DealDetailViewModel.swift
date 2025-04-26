//
//  DealDetailViewModel.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-24.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class DealDetailViewModel: ObservableObject {
    @Published var deal: Deal?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isBookmarked = false

    private let apiService = APIService.shared
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()

    func fetchDealDetails(dealId: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedDeal = try await apiService.fetchDeal(id: dealId)
                self.deal = fetchedDeal
                self.isLoading = false
                // Check if deal is already bookmarked
                self.isBookmarked = coreDataManager.isDealSaved(id: dealId)
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func toggleBookmark() {
        guard let deal = deal else { return }

        if isBookmarked {
            // Remove bookmark
            coreDataManager.deleteSavedDeal(id: deal.id)
        } else {
            // Add bookmark
            coreDataManager.saveDeal(deal)
        }

        // Toggle the bookmark state
        isBookmarked.toggle()
    }

    // Format the deal dates for display
    func formattedDateRange() -> String {
        guard let deal = deal else { return "" }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        let startDateString = dateFormatter.string(from: deal.startDate)
        let endDateString = dateFormatter.string(from: deal.expireDate)

        return "\(startDateString) - \(endDateString)"
    }

    // Check if the deal is currently active
    var isActive: Bool {
        guard let deal = deal else { return false }
        let currentDate = Date()
        return deal.isActive && currentDate >= deal.startDate
            && currentDate <= deal.expireDate
    }
}
