//
//  NearbyVendor.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-26.
//

import Foundation

struct NearbyVendor: Identifiable, Codable {
    let id: String
    let name: String
    let logo: URL
    let activeDealCount: Int
    let distance: Double
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, logo, activeDealCount, distance, location
    }

    // Helper method to convert to a full Vendor
    func toVendor() -> Vendor {
        return Vendor(
            id: id,
            name: name,
            logo: logo,
            address: "Check vendor details for address information",
            openingHours: nil,
            contactNumber: nil,
            email: nil,
            website: nil,
            socialMedia: nil,
            location: location
        )
    }
}
