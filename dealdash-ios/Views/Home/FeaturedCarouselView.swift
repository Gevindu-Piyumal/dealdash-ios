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

struct FeaturedCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedCarouselView(deals: [
            Deal(
                id: "1",
                title: "Kids dine free at Cinnamon Grand",
                description: "This is a sample deal description.",
                banner: URL(string: "https://exgljghcbqshcrapeczd.supabase.co/storage/v1/object/public/deal-images/1745329494124-34792b178d2416bd.jpg")!,
                category: Category(
                    id: "680782aff702eeb742f73ec6",
                    name: "Foods & Drink",
                    icon: URL(string: "https://exgljghcbqshcrapeczd.supabase.co/storage/v1/object/public/category-icons/1745322670167-d489d8cc764f5ed0.png")!
                ),
                startDate: Date(),
                expireDate: Date(),
                isActive: true,
                isFeatured: true,
                vendor: Vendor(
                    id: "68079732090f35443df4ff5f",
                    name: "Cinnamon Grand Colombo",
                    logo: URL(string: "https://exgljghcbqshcrapeczd.supabase.co/storage/v1/object/public/vendor-logos/1745327921426-4ff525067b5408c5.png")!,
                    address: "No. 77, Galle Road",
                    openingHours: "24H",
                    contactNumber: "+94112491000",
                    email: "info@cinnamongrand.com",
                    website: URL(string: "https://www.cinnamongrand.com")!,
                    socialMedia: SocialMedia(
                        facebook: URL(string: "https://facebook.com/cinnamongrand")!,
                        instagram: URL(string: "https://instagram.com/cinnamongrand")!,
                        whatsapp: "+94112491000"
                    ),
                    location: Location(
                        type: "Point",
                        coordinates: [79.8467213, 6.9291757]
                    )
                ),
                createdAt: Date()
            )
        ])
    }
}
