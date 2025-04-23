//
//  SearchBarView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String = "Search"
    var showMic: Bool = false
    var onSubmit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .onSubmit(onSubmit)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            } else if showMic {
                Image(systemName: "mic")
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.vertical, 4)
    }
}