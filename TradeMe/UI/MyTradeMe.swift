//
//  MyTradeMe.swift
//  TradeMe
//
//  Created by Teakin Otang on 14/11/2024.
//

import SwiftUI

struct MyTradeMe: View {
    var body: some View {
        NavigationStack() {
            Text("My Trade Me")
                .navigationTitle(Text("My Trade Me"))
        }
        .tabItem {
            Text("My Trade Me")
            Image(uiImage: UIImage(imageLiteralResourceName: "profile-16"))
        }
    }
}

#Preview {
    MyTradeMe()
}
