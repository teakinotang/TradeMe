//
//  Discover.swift
//  TradeMe
//
//  Created by Teakin Otang on 14/11/2024.
//

import SwiftUI

struct Discover: View {
    
    @State private var showingSearchAlert = false
    @State private var showingCartAlert = false
    
    var body: some View {
        NavigationStack() {
            Text("Discover")
            .navigationTitle(Text("Browse"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button { showingSearchAlert = true } label: {
                    Image(uiImage: UIImage(imageLiteralResourceName: "search"))
                }
                .alert("Search button tapped", isPresented: $showingSearchAlert) {
                    Button("OK", role: .cancel) {}
                }
                Button { showingCartAlert = true } label: {
                    Image(uiImage: UIImage(imageLiteralResourceName: "cart"))
                }
                .alert("Cart button tapped", isPresented: $showingCartAlert) {
                    Button("Ok", role: .cancel) {}
                }
            }
        }
        .tabItem {
            Text("Discover")
            Image(uiImage: UIImage(imageLiteralResourceName: "search"))
        }
        .toolbarBackground(.gray, for: .tabBar)
    }
}

#Preview {
    Discover()
}
