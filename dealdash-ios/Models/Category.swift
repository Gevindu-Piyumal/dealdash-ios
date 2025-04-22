//
//  Category.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Foundation

struct Category: Codable {
    let id: String
    let name: String
    let icon: URL

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, icon
    }
}
