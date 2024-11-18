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
        var showErrorAlert: Bool = false
        var showingSearchAlert = false
        var showingCartAlert = false
        var showListingAlert: Bool = false
        var loading = false
        
        private let network: Network
        private var cancellables: Set<AnyCancellable> = []
                        
        init(network: Network) {
            self.network = network
            updateListings()
        }
        
        private func updateListings() {
            loading = true
            network.fetchLatestListings()
                .receive(on: DispatchQueue.main)
                .sink {
                    if case .failure = $0 {
                        self.showErrorAlert = true
                        self.loading = false
                    }
                } receiveValue: { result in
                    self.loading = false
                    self.listings = result.listings
                }
                .store(in: &cancellables)
        }
        
        func tryAgain() {
            showErrorAlert = false
            updateListings()
        }
        
    }
    
}
