//
//  MapView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import MapKit
import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Deals Near You")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
                .overlay { loadingOverlay }
                .alert(
                    "Error",
                    isPresented: errorBinding,
                    actions: { Button("OK", role: .cancel) {} },
                    message: { Text(viewModel.errorMessage ?? "") }
                )
                .onAppear {
                    // Start location services when view appears
                    viewModel.getUserLocation()
                }
        }
    }

    private var contentView: some View {
        VStack(spacing: 0) {
            // Header section
            MapHeaderView(
                searchText: $viewModel.searchText,
                selectedCategory: $viewModel.selectedCategory,
                categories: viewModel.categories,
                onCategorySelect: viewModel.selectCategory
            )

            // Map section
            VendorMapSection(
                region: $viewModel.region,
                vendors: viewModel.vendors
            )

            // Vendor list
            VendorListSection(vendors: viewModel.vendors)
        }
    }

    // Toolbar content
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {}) {
                Image(systemName: "bell")
            }
        }
    }

    // Loading overlay
    @ViewBuilder
    private var loadingOverlay: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
        }
    }

    // Alert binding and content
    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }

    private func errorActions() -> some View {
        Button("OK", role: .cancel) {}
    }

    private var errorMessage: some View {
        Text(viewModel.errorMessage ?? "")
    }
}
