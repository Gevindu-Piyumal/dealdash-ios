//
//  CategoryButton.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import SwiftUI

struct CategoryButton: View, Equatable {
    let title: String
    @Binding var selectedCategory: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    selectedCategory == title ? Color.blue : Color(.systemGray6)
                )
                .foregroundColor(selectedCategory == title ? .white : .primary)
                .cornerRadius(20)
        }
    }

    static func == (lhs: CategoryButton, rhs: CategoryButton) -> Bool {
        lhs.title == rhs.title && lhs.selectedCategory == rhs.selectedCategory
    }
}
