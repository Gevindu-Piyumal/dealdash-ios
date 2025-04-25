//
//  SearchBarView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search Deals", text: $text)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }

            Image(systemName: "mic")
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
