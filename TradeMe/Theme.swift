//
//  Theme.swift
//  TradeMe
//
//  Created by Teakin Otang on 15/11/2024.
//

import Foundation
import SwiftUICore

// thanks Karan Champaneri - https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct Theme {
    
    struct TradeMeColors {
        
        static let textDark = Color(hex: 0x393531)
        static let textLight = Color(hex: 0x85807B)
        static let tasman500 = Color(hex: 0x148FE2)
        static let feijoa500 = Color(hex: 0x29A754)
        
    }
    
}
