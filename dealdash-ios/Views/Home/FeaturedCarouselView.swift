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
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 4, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $currentIndex) {
                ForEach(Array(deals.enumerated()), id: \.element.id) {
                    index,
                    deal in
                    DealRowView(deal: deal)
                        .padding(.horizontal)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 130)
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % max(1, deals.count)
                }
            }

            HStack(spacing: 6) {
                ForEach(0..<deals.count, id: \.self) { index in
                    Circle()
                        .fill(
                            currentIndex == index
                                ? Color.black : Color.gray.opacity(0.3)
                        )
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 4)
        }
    }
}

struct FeaturedCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedCarouselView(deals: [
            Deal(
                id: "1",
                title: "Kids dine free at Cinnamon Grand",
                description: "This is a sample deal description.",
                banner: URL(
                    string:
                        "https://exgljghcbqshcrapeczd.supabase.co/storage/v1/object/public/deal-images/1745329494124-34792b178d2416bd.jpg"
                )!,
                category: Category(
                    id: "680782aff702eeb742f73ec6",
                    name: "Foods & Drink",
                    icon: URL(
                        string:
                            "https://exgljghcbqshcrapeczd.supabase.co/storage/v1/object/public/category-icons/1745322670167-d489d8cc764f5ed0.png"
                    )!
                ),
                startDate: Date(),
                expireDate: Date(),
                isActive: true,
                isFeatured: true,
                vendor: Vendor(
                    id: "68079732090f35443df4ff5f",
                    name: "Cinnamon Grand Colombo",
                    logo: URL(
                        string:
                            "https://exgljghcbqshcrapeczd.supabase.co/storage/v1/object/public/vendor-logos/1745327921426-4ff525067b5408c5.png"
                    )!,
                    address: "No. 77, Galle Road",
                    openingHours: "24H",
                    contactNumber: "+94112491000",
                    email: "info@cinnamongrand.com",
                    website: URL(string: "https://www.cinnamongrand.com")!,
                    socialMedia: SocialMedia(
                        facebook: URL(
                            string: "https://facebook.com/cinnamongrand"
                        )!,
                        instagram: URL(
                            string: "https://instagram.com/cinnamongrand"
                        )!,
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
