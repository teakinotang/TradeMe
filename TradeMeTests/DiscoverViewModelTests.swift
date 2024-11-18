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
    
    var waiter = XCTWaiter()

    @Test func testViewModel_getListings_success() async {
        let network = MockNetwork()
        let listing = Listing.mock()
        let expectToSucceed = XCTestExpectation(description: "Expect network request to succeed")
        network.expectations.append(expectToSucceed)
        
        network.expectedResponses = [LatestListingResult(listings: [listing])]
        
        let viewModel = Discover.ViewModel(network: network)
        
        await waiter.fulfillment(of: [expectToSucceed])
        
        #expect(viewModel.showErrorAlert == false)
        #expect(viewModel.listings == [listing])
    }
        
    @Test func testViewModel_getListings_fail() async {
        let network = MockNetwork()
        network.shouldFail = true
        let expectation = XCTestExpectation(description: "Expect network request to fail")
        network.expectations.append(expectation)
        
        let viewModel = Discover.ViewModel(network: network)
        
        await waiter.fulfillment(of: [expectation])
        
        #expect(viewModel.showErrorAlert == true)
        #expect(viewModel.listings.isEmpty)
    }
    
    @Test func testViewModel_getListings_fails_tryAgain_succeeds() async {
        let network = MockNetwork()
        let listing = Listing.mock()
        
        network.expectedResponses = [LatestListingResult(listings: [listing])]
        network.shouldFail = true
        let expectToFail = XCTestExpectation(description: "Expect network request to fail")
        let expectToSucceed = XCTestExpectation(description: "Expect network request to succeed")
        network.expectations.append(contentsOf: [expectToFail, expectToSucceed])
        
        let viewModel = Discover.ViewModel(network: network)
        
        await waiter.fulfillment(of: [expectToFail])
        
        #expect(viewModel.showErrorAlert == true)
        #expect(viewModel.listings.isEmpty)
        
        viewModel.tryAgain()
        
        await waiter.fulfillment(of: [expectToSucceed])
        
        #expect(viewModel.showErrorAlert == false)
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

class MockNetwork: Network {
    
    var expectedResults: [Result<TradeMe.LatestListingResult, TradeMe.TradeMeError>] = []
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
