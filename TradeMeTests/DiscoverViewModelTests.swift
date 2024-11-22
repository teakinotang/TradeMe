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
        let testExpectations = [
            XCTestExpectation(description: "Expected network request to succeed")
        ]
        network.expects.append(Expect.succeed(testExpectations[0], LatestListingResult(listings: [listing])))
        
        let viewModel = Discover.ViewModel(network: network)
        #expect(viewModel.showingLoadingIndicator == true)
        await waiter.fulfillment(of: [testExpectations[0]])
        
        #expect(viewModel.showingErrorAlert == false)
        #expect(viewModel.listings == [listing])
        #expect(viewModel.showingLoadingIndicator == false)
        #expect(viewModel.listings.first?.priceDisplay == "Test")
    }
        
    @Test func testViewModel_getListings_fails() async {
        let network = MockNetwork()
        let testExpectations = [
            XCTestExpectation(description: "Expected network request to fail")
        ]
        network.expects.append(Expect.fail(testExpectations[0]))
        
        let viewModel = Discover.ViewModel(network: network)
        #expect(viewModel.showingLoadingIndicator == true)
        await waiter.fulfillment(of: [testExpectations[0]])
        
        #expect(viewModel.showingErrorAlert == true)
        #expect(viewModel.listings.isEmpty)
        #expect(viewModel.showingLoadingIndicator == false)
    }
    
    @Test func testViewModel_getListings_fails_tryAgain_succeeds() async {
        let network = MockNetwork()
        let testExpectations = [
            XCTestExpectation(description: "Expected network request to fail"),
            XCTestExpectation(description: "Expected network request to succeed")
        ]
        network.expects = [.fail(testExpectations[0]), .succeed(testExpectations[1], LatestListingResult(listings: [listing]))]
        
        let viewModel = Discover.ViewModel(network: network)
        #expect(viewModel.showingLoadingIndicator == true)
        await waiter.fulfillment(of: [testExpectations[0]])
        
        #expect(viewModel.showingErrorAlert == true)
        #expect(viewModel.listings.isEmpty)
        #expect(viewModel.showingLoadingIndicator == false)
        
        viewModel.tryAgain()
        #expect(viewModel.showingLoadingIndicator == true)
        await waiter.fulfillment(of: [testExpectations[1]])
        
        #expect(viewModel.showingErrorAlert == false)
        #expect(viewModel.listings == [listing])
        #expect(viewModel.showingLoadingIndicator == false)
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

enum Expect {
    case fail(XCTestExpectation)
    case succeed(XCTestExpectation, LatestListingResult)
}

class MockNetwork: Network {
    
    private var expectsCount = 0
    var expects: [Expect] = []
    
    func fetchLatestListings() -> Future<TradeMe.LatestListingResult, TradeMe.TradeMeError> {
        return Future { promise in
            if case let .fail(expectation) = self.expects[self.expectsCount] {
                expectation.fulfill()
                promise(.failure(TradeMeError.someError))
            } else if case let .succeed(expectation, result) = self.expects[self.expectsCount] {
                promise(.success(result))
                expectation.fulfill()
            }
            self.expectsCount += 1
        }
    }
}
