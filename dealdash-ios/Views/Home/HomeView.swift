//
//  HomeView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Search and notification
                    HStack {
                        SearchBarView(text: $vm.searchText, placeholder: "Search Deals", showMic: true) {
                            Task { await vm.search() }
                        }
                        Button { /* TODO: notifications */ } label: {
                            Image(systemName: "bell")
                                .font(.title3)
                        }
                        .padding(.trailing)
                    }
                    .padding(.horizontal)
                    
                    if vm.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                    } else {
                        // Featured section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Featured Deals")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            FeaturedCarouselView(deals: vm.featured)
                                .frame(height: 200)
                        }
                        
                        // All Deals section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("All Deals")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(vm.allDeals) { deal in
                                    DealRowView(deal: deal)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
//            .navigationTitle("DealDash")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("DealDash")
                        .font(.headline)
                }
            }
            .task { await vm.loadHome() }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
