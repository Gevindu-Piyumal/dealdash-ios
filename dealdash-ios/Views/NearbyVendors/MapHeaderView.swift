//
//  MapHeaderView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import SwiftUI

struct MapHeaderView: View {
    @Binding var searchText: String
    @Binding var selectedCategory: String
    let categories: [String]
    let onCategorySelect: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {

            Divider()
                .padding(.vertical, 8)

            // Category Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        CategoryButton(
                            title: category,
                            selectedCategory: $selectedCategory
                        ) {
                            onCategorySelect(category)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
