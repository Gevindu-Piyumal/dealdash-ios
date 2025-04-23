//
//  DealDetailView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-24.
//

import Kingfisher
import SwiftUI

struct DealDetailView: View {
    @StateObject private var viewModel = DealDetailViewModel()
    let dealId: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if let deal = viewModel.deal {
                    Text(deal.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    DealBannerView(imageURL: deal.banner)
                        .frame(height: 250)
                        .cornerRadius(12)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text(deal.description)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Valid Period")
                            .font(.headline)
                            .fontWeight(.semibold)

                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text(viewModel.formattedDateRange())

                            if viewModel.isActive {
                                Text("• Active")
                                    .foregroundColor(.green)
                                    .fontWeight(.medium)
                            } else {
                                Text("• Inactive")
                                    .foregroundColor(.red)
                                    .fontWeight(.medium)
                            }
                        }
                        .font(.subheadline)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Offered By")
                            .font(.headline)
                            .fontWeight(.semibold)

                        VendorInfoView(vendor: deal.vendor)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(viewModel.deal?.vendor.name ?? "Deal Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                }) {
                    Image(systemName: "bookmark")
                }
            }
        }
        .onAppear {
            viewModel.fetchDealDetails(dealId: dealId)
        }
    }
}

// Preview
struct DealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DealDetailView(dealId: "68079d5c090f35443df4ff7d")
        }
    }
}
