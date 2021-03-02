//
//  UnitSystem.Unit+Internal.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension UnitSystem.Unit {
    
    // NB - some of these functions are not safe & require knowledge of the units to avoid crashing
    
    var importOptionTitle: String {
        switch self {
        case .cupDry:
            return NSLocalizedString("Units_option_cupDry", bundle: .module, comment: "Dry option")
        case .cupWet:
            return NSLocalizedString("Units_option_cupWet", bundle: .module, comment: "Liquid option")
        default:
            return ""
        }
    }
    
    var decimalPlaces: Int {
        switch self {
        case .g, .ml, .mm: return 0
        case .oz, .fl, .cm, .in, .none, .serving, .tsp, .tbsp, .slice: return 1
        case .kg, .lb, .ltr, .pt, .cupDry, .cupWet, .m, .yd, .ft: return 2
        }
    }
    
    func convertToPints(_ amount: Double) -> (UnitSystem.Unit, Double) {
        var converted = convert(amount, to: .pt)!
        var unit = UnitSystem.Unit.pt
        if converted < 1 {
            converted = convert(amount, to: .fl)!
            unit = .fl
        }
        return (unit, converted)
    }
    
    func convertToPounds(_ amount: Double) -> (UnitSystem.Unit, Double) {
        var converted = convert(amount, to: .lb)!
        var unit = UnitSystem.Unit.lb
        if converted < 1 {
            converted = convert(amount, to: .oz)!
            unit = .oz
        }
        return (unit, converted)
    }
    
    func convertToLitres(_ amount: Double) -> (UnitSystem.Unit, Double) {
        var converted = convert(amount, to: .ltr)!
        var unit = UnitSystem.Unit.ltr
        if converted < 1 {
            converted = convert(amount, to: .ml)!
            unit = .ml
        }
        return (unit, converted)
    }
    
    func convertToKilos(_ amount: Double) -> (UnitSystem.Unit, Double) {
        var converted = convert(amount, to: .kg)!
        var unit = UnitSystem.Unit.kg
        if converted < 1 {
            converted = convert(amount, to: .g)!
            unit = .g
        }
        return (unit, converted)
    }
    
    func convertToYards(_ amount: Double) -> (UnitSystem.Unit, Double) {
        var converted = convert(amount, to: .yd)!
        var unit = UnitSystem.Unit.yd
        if converted < 1 {
            converted = convert(amount, to: .ft)!
            unit = .ft
        }
        if converted < 1 {
            converted = convert(amount, to: .in)!
            unit = .in
        }
        return (unit, converted)
    }
    
    func convertToMetres(_ amount: Double) -> (UnitSystem.Unit, Double) {
        var converted = convert(amount, to: .m)!
        var unit = UnitSystem.Unit.m
        if converted < 1 {
            converted = convert(amount, to: .cm)!
            unit = .cm
        }
        return (unit, converted)
    }
    
    func shouldShowSingular(_ amount: Double) -> Bool {
        return amount * 4 == floor(amount * 4) && amount <= 1
    }
    
    func symbolicated(for amount: Double) -> String? {
        
        let fraction = amount.truncatingRemainder(dividingBy: 1)
        
        let symbol: String?
        
        switch fraction {
        case 0.25:
            symbol = "¼"
        case 0.5:
            symbol = "½"
        case 0.75:
            symbol = "¾"
        default:
            symbol = nil
        }
        
        if let symbol = symbol {
            return amount > 1 ? "\(Int(amount))\(symbol)" : symbol
        }
        
        return nil
    }
}
