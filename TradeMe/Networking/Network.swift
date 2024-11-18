//
//  Network.swift
//  TradeMe
//
//  Created by Teakin Otang on 14/11/2024.
//

import Foundation
import OAuthSwift
import Combine

protocol Network {
    func fetchLatestListings() -> Future<LatestListingResult, TradeMeError>
}

// TODO: Proper error handling
enum TradeMeError: Error {
    case someError
}

class ConcreteNetwork: Network {
    
    func fetchLatestListings() -> Future<LatestListingResult, TradeMeError> {
        // TODO: In the real world these should be safely stored away in the Keychain
        let oAuthSwift = OAuth1Swift(
            consumerKey: "A1AC63F0332A131A78FAC304D007E7D1",
            consumerSecret: "EC7F18B17A062962C6930A8AE88B16C7"
        )
        
        return Future { promise in
            Task.init {
                oAuthSwift.client.get("https://api.tmsandbox.co.nz/v1/listings/latest.json?rows=20") { result in
                    switch result {
                    case .success(let response):
                        do {
                            let latestListingResult = try JSONDecoder().decode(LatestListingResult.self, from: response.data)
                            promise(.success(latestListingResult))
                        } catch {
                            promise(.failure(TradeMeError.someError))
                        }
                    case .failure:
                        promise(.failure(TradeMeError.someError))
                    }
                }
            }
        }
    }
}

struct LatestListingResult: Decodable {
    
    var listings: [Listing]
    
    enum CodingKeys: String, CodingKey {
        case listings = "List"
    }
    
}

struct Listing: Decodable, Identifiable, Equatable {
    var id: Int
    var title: String
    var startPrice: Double
    var buyNowPrice: Double?
    var region: String
    var pictureHref: String?
    var isClassified: Bool?
    var priceDisplay: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "ListingId"
        case title = "Title"
        case startPrice = "StartPrice"
        case buyNowPrice = "BuyNowPrice"
        case region = "Region"
        case pictureHref = "PictureHref"
        case isClassified = "IsClassified"
        case priceDisplay = "PriceDisplay"
    }
}
