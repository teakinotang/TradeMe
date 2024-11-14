//
//  ContentView.swift
//  TradeMe
//
//  Created by Teakin Otang on 14/11/2024.
//

import SwiftUI

struct ContentView: View {
    @State var selection: Int = 0
    var body: some View {
        TabView(selection: $selection) {
            Discover()
            Watchlist()
            MyTradeMe()
        }
    }
}

#Preview {
    ContentView()
}
