//
//  MapViewModel.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-26.
//

import MapKit
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var vendors: [NearbyVendor] = []
    @Published var selectedCategory: String = "All"
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 6.9177940,
            longitude: 79.8459039
        ),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    private var locationManager: CLLocationManager?
    private var cancellable: Task<Void, Never>?

    var categories = [
        "All", "Automobile", "Beauty & Spa", "Electronics", "Entertainment",
        "Fashion", "Foods & Drink", "Online", "Supermarket", "Telecom",
        "Travel",
    ]

    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }

    func fetchVendors() async {
        cancellable?.cancel()

        cancellable = Task {
            await MainActor.run {
                isLoading = true
                errorMessage = nil
            }

            do {
                let fetchedVendors = try await APIService.shared
                    .fetchNearbyVendors(
                        longitude: region.center.longitude,
                        latitude: region.center.latitude,
                        category: selectedCategory == "All"
                            ? "" : selectedCategory
                    )

                await MainActor.run {
                    vendors =
                        searchText.isEmpty
                        ? fetchedVendors
                        : fetchedVendors.filter {
                            $0.name.localizedCaseInsensitiveContains(searchText)
                        }
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage =
                        "Failed to fetch vendors: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }

    func selectCategory(_ category: String) {
        guard selectedCategory != category else { return } // Avoid redundant updates
        selectedCategory = category
        Task {
            await fetchVendors()
        }
    }

    func getUserLocation() {
        locationManager?.startUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            // Stop updating location to conserve battery
            locationManager?.stopUpdatingLocation()

            // Update the map region with user's current location
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.05,
                        longitudeDelta: 0.05
                    )
                )

                // Fetch vendors based on new location
                Task {
                    await self.fetchVendors()
                }
            }
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        DispatchQueue.main.async {
            self.errorMessage =
                "Failed to get your location: \(error.localizedDescription)"
            self.isLoading = false
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            getUserLocation()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.errorMessage =
                    "Location access denied. Please enable location services in Settings."
            }
        case .notDetermined:
            // Wait for user decision
            break
        @unknown default:
            break
        }
    }
}
