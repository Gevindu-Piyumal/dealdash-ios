//
//  HomeViewModel.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var featured: [Deal] = []
    @Published var allDeals: [Deal] = []
    @Published var filteredDeals: [Deal] = []
    @Published var isLoading = false

    func loadHome() async {
        isLoading = true
        async let featuredTask = APIService.shared.fetchDeals(featured: true)
        async let allDealsTask = APIService.shared.fetchDeals()

        do {
            featured = try await featuredTask
            allDeals = try await allDealsTask
        } catch {
            print("loadHome error:", error)
        }

        isLoading = false
    }

    func search() async {
        if searchText.isEmpty {
            filteredDeals = allDeals
            return
        }

        let searchQuery = searchText.lowercased()
        filteredDeals = allDeals.filter { deal in
            deal.vendor.name.lowercased().contains(searchQuery)
                || deal.title.lowercased().contains(searchQuery)
                || deal.description.lowercased().contains(searchQuery)
        }
    }
}
