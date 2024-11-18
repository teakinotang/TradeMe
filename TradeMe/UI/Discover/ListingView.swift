//
//  ListingView.swift
//  TradeMe
//
//  Created by Teakin Otang on 15/11/2024.
//

import Foundation
import SwiftUICore
import SwiftUI

struct ListingView: View {
    let listing: Listing
    
    var body: some View {
        HStack() {
            if let imageURL = listing.pictureHref {
                AsyncImage(url: URL(string: imageURL))
                    .frame(width: 70, height: 70)
                    .scaledToFit()
                    .clipShape(Rectangle())
            } else {
                Image(systemName: "photo.badge.exclamationmark")
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Rectangle())
            }
            VStack(alignment: .leading) {
                Text(listing.region)
                    .font(.caption)
                    .foregroundStyle(Theme.TradeMeColors.textLight)
                Text(listing.title)
                    .font(.subheadline)
                    .foregroundStyle(Theme.TradeMeColors.textDark)
                Spacer()
                if let isClassified = listing.isClassified, isClassified == true {
                    Text(listing.priceDisplay)
                        .font(.subheadline)
                        .foregroundStyle(Theme.TradeMeColors.textDark)
                } else {
                    Text(listing.priceDisplay)
                        .foregroundStyle(Theme.TradeMeColors.textDark)
                        .font(.subheadline)
                    if let buyNow = listing.buyNowPrice {
                        Text(buyNow.description)
                            .font(.subheadline)
                            .foregroundStyle(Theme.TradeMeColors.textDark)
                    }
                }
            }
        }
    }
}

#Preview {
    ListingView(listing: Listing(id: 4324, title: "Test thingy", startPrice: 20.0, region: "Wellington", pictureHref: "https://images.tmsandbox.co.nz/photoserver/thumb/4227447.jpg", priceDisplay: "Buy now for $30.99"))
    ListingView(listing: Listing(id: 4324, title: "Test thingy", startPrice: 20.0, region: "Wellington", pictureHref: "https://images.tmsandbox.co.nz/photoserver/thumb/4227447.jpg", priceDisplay: "Buy now for $30.99"))
    ListingView(listing: Listing(id: 4324, title: "Test thingy", startPrice: 20.0, region: "Wellington", pictureHref: "https://images.tmsandbox.co.nz/photoserver/thumb/4227447.jpg", priceDisplay: "Buy now for $30.99"))
    ListingView(listing: Listing(id: 4324, title: "Test thingy", startPrice: 20.0, region: "Wellington", pictureHref: "https://images.tmsandbox.co.nz/photoserver/thumb/4227447.jpg", priceDisplay: "Buy now for $30.99"))
}
