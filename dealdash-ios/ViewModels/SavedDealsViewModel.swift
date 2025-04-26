//
//  SavedDealsViewModel.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-26.
//

import Foundation
import SwiftUI

class SavedDealsViewModel: ObservableObject {
    @Published var savedDeals: [Deal] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    func loadSavedDeals() {
        savedDeals = coreDataManager.fetchSavedDeals()
    }
    
    func deleteSavedDeal(at offsets: IndexSet) {
        for index in offsets {
            let deal = savedDeals[index]
            coreDataManager.deleteSavedDeal(id: deal.id)
        }
        loadSavedDeals()
    }
}
