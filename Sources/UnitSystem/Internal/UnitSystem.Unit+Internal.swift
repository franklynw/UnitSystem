//
//  UnitSystem.Unit+Internal.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension UnitSystem.Unit {
    
    // NB - some of these functions are not safe & require knowledge of the units to avoid crashing
    
    enum UnitType {
        case weight
        case volume
        case distance
        case misc
        case none
    }
    
    var value: Double {
        switch self {
        case .kg: return 1
        case .g: return 0.001
        case .lb: return 0.45359
        case .oz: return 0.02835
        case .cupDry: return 0.2
        case .ltr: return 1
        case .ml: return 0.001
        case .pt: return Locale.isUS ? 0.473 : 0.568
        case .fl: return Locale.isUS ? 0.02956 : 0.0284
        case .cupWet: return Locale.isUS ? 0.23659 : 0.25
        case .m: return 1
        case .cm: return 0.01
        case .mm: return 0.001
        case .yd: return 0.9144
        case .ft: return 0.3048
        case .in: return 0.0254
        case .tsp: return 1
        case .tbsp: return 1
        case .slice: return 1
        case .serving: return 1
        case .none: return 1
        }
    }
    
    var unitType: UnitType {
        switch self {
        case .kg, .g, .lb, .oz, .cupDry:
            return .weight
        case .ltr, .ml, .pt, .fl, .cupWet:
            return .volume
        case .m, .cm, .mm, .yd, .ft, .in:
            return .distance
        case .tsp, .tbsp, .slice, .serving:
            return .misc
        case .none:
            return .none
        }
    }
    
    
    
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
    
    var allConversionOptions: [UnitSystem.Unit] {
        
        switch unitType {
        case .weight:
            return [.kg, .g, .lb, .oz, .cupDry]
        case .volume:
            return [.ltr, .ml, .pt, .fl, .cupWet]
        case .distance:
            return [.m, .cm, .mm, .yd, .ft, .in]
        case .misc, .none:
            return []
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
