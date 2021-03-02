//
//  UnitSystem+Localizing.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension UnitSystem: Localizing {
    
    var localizedKey: String {
        return "UnitSystem_" + rawValue
    }
}
