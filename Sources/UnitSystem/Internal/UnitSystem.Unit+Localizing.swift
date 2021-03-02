//
//  UnitSystem.Unit+Localizing.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension UnitSystem.Unit: Localizing {
    
    var localizedKey: String {
        return "Units_" + rawValue
    }
}
