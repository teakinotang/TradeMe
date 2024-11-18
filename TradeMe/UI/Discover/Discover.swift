//
//  Discover.swift
//  TradeMe
//
//  Created by Teakin Otang on 14/11/2024.
//

import SwiftUI

struct Discover: View {
    
    @State private var viewModel: ViewModel
            
    init(network: Network) {
        viewModel = ViewModel(network: network)
    }
    
    var body: some View {
        NavigationStack() {
            ZStack {
                if viewModel.loading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.listings) { listing in
                            ListingView(listing: listing)
                                .onTapGesture() {
                                    viewModel.showListingAlert = true
                                }
                                .alert(listing.title, isPresented: $viewModel.showListingAlert) {
                                    Button("Dismiss") {
                                        viewModel.showListingAlert = false
                                    }
                                }
                        }
                    }
                    .alert("Something went wrong", isPresented: $viewModel.showErrorAlert) {
                        Button("Try again", role: .cancel) {
                            viewModel.tryAgain()
                        }
                    }
                    .navigationTitle(Text("Browse"))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button { viewModel.showingSearchAlert = true } label: {
                            Image(uiImage: UIImage(imageLiteralResourceName: "search"))
                        }
                        .alert("Search button tapped", isPresented: $viewModel.showingSearchAlert) {
                            Button("OK", role: .cancel) {}
                        }
                        Button { viewModel.showingCartAlert = true } label: {
                            Image(uiImage: UIImage(imageLiteralResourceName: "cart"))
                        }
                        .alert("Cart button tapped", isPresented: $viewModel.showingCartAlert) {
                            Button("Ok", role: .cancel) {}
                        }
                    }
                }
            }
        }
        .tabItem {
            Text("Discover")
            Image(uiImage: UIImage(imageLiteralResourceName: "search"))
        }
    }
}

#Preview {
    Discover(network: ConcreteNetwork())
}
