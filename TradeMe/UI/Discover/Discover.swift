//
//  Discover.swift
//  TradeMe
//
//  Created by Teakin Otang on 14/11/2024.
//

import SwiftUI

// TODO: Pull strings out of a resource file instead of hard coding them here. Potentially do this via the view model.
struct Discover: View {
    
    @State private var viewModel: ViewModel
    
    // TODO: Dependency injection
    init(network: Network) {
        viewModel = ViewModel(network: network)
    }
    
    var body: some View {
        NavigationStack() {
            if viewModel.showingLoadingIndicator {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.listings) { listing in
                        ListingView(listing: listing)
                        .onTapGesture() {
                            viewModel.showingListingAlert = true
                        }
                        // TODO: Fix bug causing incorrect title to be displayed :P
                        .alert(listing.title, isPresented: $viewModel.showingListingAlert) {
                            Button("Dismiss") {
                                viewModel.showingListingAlert = false
                            }
                        }
                    }
                }
                .alert("Something went wrong", isPresented: $viewModel.showingErrorAlert) {
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
        .tabItem {
            Text("Discover")
            Image(uiImage: UIImage(imageLiteralResourceName: "search"))
        }
    }
}

#Preview {
    Discover(network: ConcreteNetwork())
}
