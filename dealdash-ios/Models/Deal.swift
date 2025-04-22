//
//  Deal.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Foundation

struct Deal: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let banner: URL
    let category: Category
    let startDate: Date
    let expireDate: Date
    let isActive: Bool
    let isFeatured: Bool
    let vendor: Vendor
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, banner, category, startDate, expireDate, isActive, isFeatured, vendor, createdAt
    }
}
