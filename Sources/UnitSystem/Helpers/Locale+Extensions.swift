//
//  Locale+Extensions.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension Locale {
    
    static var isUS: Bool {
        return current.currencyCode == "USD" // cos the US has some unusual units for volume measurements
    }
}
