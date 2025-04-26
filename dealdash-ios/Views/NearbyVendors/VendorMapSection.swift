//
//  VendorMapSection.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import MapKit
import SwiftUI

struct VendorMapSection: View {
    @Binding var region: MKCoordinateRegion
    let vendors: [NearbyVendor]
    @State private var selectedVendor: NearbyVendor? = nil

    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $region,
                annotationItems: vendors
            ) { vendor in
                MapMarker(
                    coordinate: getCoordinateForVendor(vendor),
                    tint: .blue
                )
            }
            .frame(height: 300)
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top, 8)
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    // Request user location again
                    LocationManager.shared.startUpdatingLocation()
                }) {
                    Image(systemName: "location.fill")
                        .padding(12)
                        .background(Circle().fill(.white))
                        .shadow(radius: 2)
                }
                .padding([.trailing, .bottom], 20)
            }
        }
        .sheet(item: $selectedVendor) { vendor in
            VendorDetailView(vendor: vendor.toVendor())
        }
    }

    private func getCoordinateForVendor(_ vendor: NearbyVendor)
        -> CLLocationCoordinate2D
    {
        if let location = vendor.location {
            return CLLocationCoordinate2D(
                latitude: location.coordinates[1],
                longitude: location.coordinates[0]
            )
        } else {
            return CLLocationCoordinate2D(
                latitude: region.center.latitude
                    + Double.random(in: -0.01...0.01),
                longitude: region.center.longitude
                    + Double.random(in: -0.01...0.01)
            )
        }
    }
}

// Extension to make NearbyVendor identifiable
extension NearbyVendor {
    
}
