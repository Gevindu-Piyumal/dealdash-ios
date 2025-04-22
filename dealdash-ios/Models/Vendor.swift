//
//  Vendor.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Foundation

struct Vendor: Identifiable, Codable {
    let id: String
    let name: String
    let logo: URL
    let address: String
    let openingHours: String?
    let contactNumber: String?
    let email: String?
    let website: URL?
    let socialMedia: SocialMedia?
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, logo, address
        case openingHours, contactNumber, email, website
        case socialMedia, location
    }
}
