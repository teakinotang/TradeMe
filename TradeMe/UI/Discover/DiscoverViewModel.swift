//
//  DiscoverViewModel.swift
//  TradeMe
//
//  Created by Teakin Otang on 15/11/2024.
//

import Foundation
import SwiftUICore
import Combine

extension Discover {
    
    @Observable
    class ViewModel {
        
        var listings: [Listing] = []
        var showingErrorAlert = false
        var showingSearchAlert = false
        var showingCartAlert = false
        var showingListingAlert = false
        var showingLoadingIndicator = false
        
        private let network: Network
        private var cancellables: Set<AnyCancellable> = []
        
        // TODO: Dependency injection
        init(network: Network) {
            self.network = network
            updateListings()
        }
        
        // TODO: Strong capture of self in `network.fetchLatestListings` closures probably isn't safe
        private func updateListings() {
            showingLoadingIndicator = true
            // TODO: Make it possible to cancel this request if it starts to take too long
            network.fetchLatestListings()
                .receive(on: DispatchQueue.main)
                .sink {
                    if case .failure = $0 {
                        self.showingErrorAlert = true
                        self.showingLoadingIndicator = false
                    }
                } receiveValue: { result in
                    self.showingLoadingIndicator = false
                    self.listings = result.listings
                }
                .store(in: &cancellables)
        }
        
        func tryAgain() {
            showingErrorAlert = false
            updateListings()
        }
        
    }
    
}
