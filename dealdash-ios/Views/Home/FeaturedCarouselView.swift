//
//  FeaturedCarouselView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Kingfisher
import SwiftUI

struct FeaturedCarouselView: View {
    let deals: [Deal]

    var body: some View {
        TabView {
            ForEach(deals) { deal in
                ZStack(alignment: .bottomLeading) {
                    KFImage(deal.banner)
                        .resizable()
                        .scaledToFill()
                        .clipped()

                    Text(deal.title)
                        .font(.subheadline)
                        .padding(8)
                        .background(.black.opacity(0.5))
                        .foregroundColor(.white)
                }
                .cornerRadius(12)
                .padding(.horizontal, 8)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
