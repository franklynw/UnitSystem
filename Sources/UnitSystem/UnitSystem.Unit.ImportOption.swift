//
//  UnitSystem.Unit.ImportOption.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension UnitSystem.Unit {
    
    public struct ImportOption: Identifiable {
        public let id = UUID().uuidString
        public let title: String
        public let unit: UnitSystem.Unit
    }
}
