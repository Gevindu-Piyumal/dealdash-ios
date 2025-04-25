//
//  VendorDetailView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import MapKit
import SwiftUI

struct VendorDetailView: View {
    let vendor: Vendor
    @StateObject private var viewModel = VendorDetailViewModel()
    @State private var selectedTab = 0
    @State private var region: MKCoordinateRegion
    @State private var fullVendorDetails: Vendor?

    init(vendor: Vendor) {
        self.vendor = vendor

        // Initialize with vendor location if available, otherwise use default
        if let location = vendor.location,
            location.coordinates.count >= 2
        {
            let coordinate = CLLocationCoordinate2D(
                latitude: location.coordinates[1],
                longitude: location.coordinates[0]
            )
            _region = State(
                initialValue: MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            )
        } else {
            // Default location
            _region = State(
                initialValue: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: 6.9271,
                        longitude: 79.8612
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.05,
                        longitudeDelta: 0.05
                    )
                )
            )
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            tabPicker
                .padding(.top, 8)

            Divider()
                .padding(.top, 8)

            TabView(selection: $selectedTab) {
                aboutView.tag(0)
                liveDealsView.tag(1)
                expiredDealsView.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.default, value: selectedTab)
        }
        .navigationTitle(vendor.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {

                }) {
                    Image(systemName: "bell")
                        .foregroundColor(.primary)
                }
            }
        }
        .task {
            // Fetch full vendor details first
            await fetchFullVendorDetails()

            await viewModel.fetchActiveDeals(for: vendor.id)
            await viewModel.fetchExpiredDeals(for: vendor.id)
        }
    }

    private func fetchFullVendorDetails() async {
        do {
            let vendorDetails = try await APIService.shared.fetchVendor(
                id: vendor.id
            )
            self.fullVendorDetails = vendorDetails

            // Update map region if location is available
            if let location = vendorDetails.location,
                location.coordinates.count >= 2
            {
                let coordinate = CLLocationCoordinate2D(
                    latitude: location.coordinates[1],
                    longitude: location.coordinates[0]
                )

                // Update the map region
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            }
        } catch {
            print("Error fetching vendor details: \(error)")
        }
    }

    private var tabPicker: some View {
        HStack(spacing: 0) {
            tabButton(title: "About", index: 0)
            tabButton(title: "Live Deals", index: 1)
            tabButton(title: "Expired Deals", index: 2)
        }
    }

    private func tabButton(title: String, index: Int) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack(spacing: 8) {
                Text(title)
                    .fontWeight(selectedTab == index ? .semibold : .regular)
                    .foregroundColor(selectedTab == index ? .blue : .gray)

                // Indicator line
                Rectangle()
                    .fill(selectedTab == index ? Color.blue : Color.clear)
                    .frame(height: 2)
            }
        }
        .frame(maxWidth: .infinity)

    }

    private var aboutView: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Map
                Map(
                    coordinateRegion: $region,
                    annotationItems: [
                        MapAnnotation(
                            coordinate: region.center,
                            title: vendor.name
                        )
                    ]
                ) { annotation in
                    MapMarker(coordinate: annotation.coordinate, tint: .purple)
                }
                .frame(height: 320)
                .overlay(
                    // Show loading indicator if location not available yet
                    Group {
                        if region.center.latitude == 0
                            && region.center.longitude == 0
                        {
                            ProgressView()
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: .infinity
                                )
                                .background(Color.white.opacity(0.6))
                        }
                    }
                )

                // Vendor details - use fullVendorDetails when available
                VStack(alignment: .leading, spacing: 24) {
                    // Get the most complete vendor object
                    let displayVendor = fullVendorDetails ?? vendor

                    infoSection(
                        title: "Address:",
                        detail: displayVendor.address
                    )

                    if let hours = displayVendor.openingHours {
                        infoSection(title: "Opening Hours:", detail: hours)
                    }

                    if let email = displayVendor.email {
                        infoSection(title: "Email:", detail: email)
                    }

                    if let phone = displayVendor.contactNumber {
                        infoSection(title: "Phone:", detail: phone)
                    }

                    if let socialMedia = displayVendor.socialMedia {
                        socialMediaSection(socialMedia: socialMedia)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }

    private func infoSection(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)

            Text(detail)
                .font(.body)
        }
    }

    private func socialMediaSection(socialMedia: SocialMedia) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Social Media:")
                .font(.headline)
                .fontWeight(.medium)

            HStack(spacing: 20) {
                if let facebook = socialMedia.facebook {
                    Link(destination: facebook) {
                        Image(systemName: "f.circle.fill")
                            .font(.title)
                            .foregroundColor(Color.blue)
                    }
                }

                if let instagram = socialMedia.instagram {
                    Link(destination: instagram) {
                        Image(systemName: "camera.circle.fill")
                            .font(.title)
                            .foregroundColor(Color.purple)
                    }
                }

                if let whatsapp = socialMedia.whatsapp {
                    if let url = URL(
                        string:
                            "https://wa.me/\(whatsapp.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+", with: ""))"
                    ) {
                        Link(destination: url) {
                            Image(systemName: "message.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.green)
                        }
                    }
                }
            }
        }
    }

    private var liveDealsView: some View {
        ScrollView {
            if viewModel.isLoadingActive {
                ProgressView()
                    .padding(.top, 100)
            } else if viewModel.activeDeals.isEmpty {
                Text("No active deals available")
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.activeDeals) { deal in
                        NavigationLink(
                            destination: DealDetailView(dealId: deal.id)
                        ) {
                            DealRowView(deal: deal)
                        }
                    }
                }
                .padding()
            }
        }
    }

    private var expiredDealsView: some View {
        ScrollView {
            if viewModel.isLoadingExpired {
                ProgressView()
                    .padding(.top, 100)
            } else if viewModel.expiredDeals.isEmpty {
                Text("No expired deals available")
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.expiredDeals) { deal in
                        NavigationLink(
                            destination: DealDetailView(dealId: deal.id)
                        ) {
                            DealRowView(deal: deal)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// Helper struct for map annotations
struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String

    init(coordinate: CLLocationCoordinate2D, title: String = "") {
        self.coordinate = coordinate
        self.title = title
    }
}
