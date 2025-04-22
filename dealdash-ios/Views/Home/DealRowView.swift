//
//  DealRowView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Kingfisher
import SwiftUI

struct DealRowView: View {
    let deal: Deal

    var body: some View {
        HStack(spacing: 12) {
            KFImage(deal.banner)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 80)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(deal.title)
                    .font(.subheadline).bold()
                    .lineLimit(2)

                Text(deal.category.name)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(deal.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(8)
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}
