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
            VStack(spacing: 0) {  // Changed to VStack to keep header sticky
                Divider()  // Divider below search bar

                ScrollView {
                    VStack(spacing: 0) {
                        if vm.isLoading {
                            ProgressView()
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: .infinity
                                )
                                .padding(.top, 10)
                        } else {
                            // Featured section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Featured Deals")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .padding(.top)

                                FeaturedCarouselView(deals: vm.featured)
                            }

                            // All Deals section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("All Deals")
                                    .font(.headline)
                                    .padding(.horizontal)

                                LazyVStack(spacing: 12) {
                                    ForEach(
                                        vm.searchText.isEmpty
                                            ? vm.allDeals : vm.filteredDeals
                                    ) { deal in
                                        DealRowView(deal: deal)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("DealDash")
                        .font(.title)
                        .fontWeight(.bold)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "bell")
                            .font(.title3)
                    }
                }
            }
            .searchable(
                text: $vm.searchText,
                placement: .navigationBarDrawer,
                prompt: "Search Deals"
            )
            .onChange(of: vm.searchText) {
                Task {
                    await vm.search()
                }
            }
            .onSubmit(of: .search) {
                Task { await vm.search() }
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
