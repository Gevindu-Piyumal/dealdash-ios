//
//  HomeViewModel.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var featured: [Deal] = []
    @Published var allDeals: [Deal] = []
    @Published var isLoading = false
    @Published var searchText = ""

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
        guard !searchText.isEmpty else {
            await loadHome()
            return
        }
    }
}
