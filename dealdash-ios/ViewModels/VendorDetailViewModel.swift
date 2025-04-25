//
//  VendorDetailViewModel.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import Foundation

class VendorDetailViewModel: ObservableObject {
    @Published var activeDeals: [Deal] = []
    @Published var expiredDeals: [Deal] = []
    @Published var isLoadingActive = false
    @Published var isLoadingExpired = false
    @Published var errorMessage: String?

    func fetchActiveDeals(for vendorId: String) async {
        await MainActor.run { isLoadingActive = true }

        do {
            let deals = try await APIService.shared.fetchDealsByVendor(
                vendorId: vendorId,
                active: true
            )
            await MainActor.run {
                self.activeDeals = deals
                self.isLoadingActive = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoadingActive = false
            }
        }
    }

    func fetchExpiredDeals(for vendorId: String) async {
        await MainActor.run { isLoadingExpired = true }

        do {
            let deals = try await APIService.shared.fetchDealsByVendor(
                vendorId: vendorId,
                active: false
            )
            await MainActor.run {
                self.expiredDeals = deals
                self.isLoadingExpired = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoadingExpired = false
            }
        }
    }
}
