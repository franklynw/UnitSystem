//
//  NumberFormatter+Extensions.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension NumberFormatter {
    
    static let singleDecimalPlaceFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()
    
    static let twoDecimalPlacesFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
}
