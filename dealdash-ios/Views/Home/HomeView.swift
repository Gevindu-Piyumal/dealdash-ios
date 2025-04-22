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
            VStack(spacing: 16) {
                HStack {
                    SearchBarView(text: $vm.searchText) {
                        Task { await vm.search() }
                    }
                    Button { /* TODO: notifications */
                    } label: {
                        Image(systemName: "bell")
                            .font(.title3)
                    }
                    .padding(.trailing)
                }
                .padding(.horizontal)

                if vm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    FeaturedCarouselView(deals: vm.featured)
                        .frame(height: 200)

                    Text("All Deals")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.allDeals) { deal in
                                DealRowView(deal: deal)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Deals")
            .task { await vm.loadHome() }
        }
    }
}
