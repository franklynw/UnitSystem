//
//  UnitSystem.Unit.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension UnitSystem {
    
    public enum Unit: String, CaseIterable {
        case none
        case serving
        case kg
        case g
        case lb
        case oz
        case ltr
        case ml
        case pt
        case fl
        case tsp
        case tbsp
        case cupDry
        case cupWet
        case m
        case cm
        case mm
        case yd
        case ft
        case `in`
        case slice
    }
}
