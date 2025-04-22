//
//  SearchBarView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var onSubmit: () -> Void

    var body: some View {
        HStack {
            TextField("Search Deals", text: $text, onCommit: onSubmit)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            Button(action: onSubmit) {
                Image(systemName: "magnifyingglass")
                    .padding(8)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
            }
        }
    }
}
