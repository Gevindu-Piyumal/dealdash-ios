//
//  DealBannerView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-24.
//

import Kingfisher
import SwiftUI

struct DealBannerView: View {
    let imageURL: URL

    var body: some View {
        KFImage(imageURL)
            .onFailureImage(KFCrossPlatformImage(systemName: "photo")!)
            .resizable()
            .placeholder {
                ZStack {
                    Color(UIColor.systemGray6)
                    ProgressView()
                }
            }
            .fade(duration: 0.25)
            .aspectRatio(contentMode: .fill)
    }
}

struct DealBannerView_Previews: PreviewProvider {
    static var previews: some View {
        DealBannerView(
            imageURL: URL(
                string:
                    "https://exgljghcbqshcrapeczd.supabase.co/storage/v1/object/public/deal-images/1745329494124-34792b178d2416bd.jpg"
            )!
        )
        .frame(height: 250)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
