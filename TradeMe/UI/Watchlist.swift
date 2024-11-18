//
//  Discover.swift
//  TradeMe
//
//  Created by Teakin Otang on 14/11/2024.
//

import SwiftUI

struct Watchlist: View {
    var body: some View {
        NavigationStack() {
            Text("Watchlist")
                .navigationTitle(Text("Watchlist"))
                .navigationBarTitleDisplayMode(.inline)
        }
        .tabItem {
            Text("Watchlist")
            Image(uiImage: UIImage(imageLiteralResourceName: "watchlist"))
        }
    }
}

#Preview {
    Watchlist()
}
