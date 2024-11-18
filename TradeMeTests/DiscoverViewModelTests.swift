//
//  TradeMeTests.swift
//  TradeMeTests
//
//  Created by Teakin Otang on 14/11/2024.
//

import Testing
import XCTest
@testable import TradeMe
import Combine

struct DiscoverViewModelTests {
    
    private var waiter = XCTWaiter()
    let listing = Listing.mock()

    @Test func testViewModel_getListings_success() async {
        let network = MockNetwork()
        
        let expectToSucceed = XCTestExpectation(description: "Expected network request to succeed")
        network.expectations.append(expectToSucceed)
        network.expectedResponses = [LatestListingResult(listings: [listing])]
        
        let viewModel = Discover.ViewModel(network: network)
        
        await waiter.fulfillment(of: [expectToSucceed])
        
        #expect(viewModel.showingErrorAlert == false)
        #expect(viewModel.listings == [listing])
    }
        
    @Test func testViewModel_getListings_fails() async {
        let network = MockNetwork()
        network.shouldFail = true
        let expectation = XCTestExpectation(description: "Expected network request to fail")
        network.expectations.append(expectation)
        
        let viewModel = Discover.ViewModel(network: network)
        
        await waiter.fulfillment(of: [expectation])
        
        #expect(viewModel.showingErrorAlert == true)
        #expect(viewModel.listings.isEmpty)
    }
    
    @Test func testViewModel_getListings_fails_tryAgain_succeeds() async {
        let network = MockNetwork()
        
        network.expectedResponses = [LatestListingResult(listings: [listing])]
        network.shouldFail = true
        let expectToFail = XCTestExpectation(description: "Expected network request to fail")
        let expectToSucceed = XCTestExpectation(description: "Expected network request to succeed")
        network.expectations.append(contentsOf: [expectToFail, expectToSucceed])
        
        let viewModel = Discover.ViewModel(network: network)
        
        await waiter.fulfillment(of: [expectToFail])
        
        #expect(viewModel.showingErrorAlert == true)
        #expect(viewModel.listings.isEmpty)
        
        viewModel.tryAgain()
        
        await waiter.fulfillment(of: [expectToSucceed])
        
        #expect(viewModel.showingErrorAlert == false)
        #expect(viewModel.listings == [listing])
    }

}

extension Listing {
    
    static func mock() -> Listing {
        return .init(
            id: Int.random(in: Range<Int>(1...1000)),
            title: "Test",
            startPrice: 100,
            region: "Test",
            priceDisplay: "Test"
        )
    }
    
}


// TODO: Not this :P what started off as a simple set of unit tests has turned in to something pretty fugly
// TODO: Use a mocking framework instead of hacking this together
class MockNetwork: Network {
    
    var responseCount = 0
    var expectationCount = 0
    var shouldFail = false
    
    var expectedResponses: [LatestListingResult] = []
    var expectations: [XCTestExpectation] = []
    
    func fetchLatestListings() -> Future<TradeMe.LatestListingResult, TradeMe.TradeMeError> {
        return Future { promise in
            if self.shouldFail {
                self.shouldFail = false
                promise(.failure(TradeMeError.someError))
                self.expectations[self.expectationCount].fulfill()
                self.expectationCount += 1
            } else {
                let expectedResponse = self.expectedResponses[self.responseCount]
                promise(.success(expectedResponse))
                self.expectations[self.expectationCount].fulfill()
                self.expectationCount += 1
                self.responseCount += 1
            }
        }
    }
}
