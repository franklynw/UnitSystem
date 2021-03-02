//
//  UnitSystem.Unit+PublicImplementations.swift
//
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension UnitSystem.Unit {
    
    init(_ candidate: String) {

        // TODO: - localise

        switch candidate.lowercased() {
        case "kg", "kgs", "kilo", "kilogram", "kilogramme", "kilos", "kilograms", "kilogrammes":
            self = .kg
        case "g", "gs", "gram", "gramme", "grams", "grammes":
            self = .g
        case "lb", "lbs", "pound", "pounds":
            self = .lb
        case "oz", "ozs", "ounce", "ounces":
            self = .oz
        case "l", "ls", "lt", "lts", "ltr", "ltrs", "litre", "litres", "liter", "liters":
            self = .ltr
        case "ml", "mls", "millilitre", "millilitres", "milliliter", "milliliters":
            self = .ml
        case "pt", "pts", "pint", "pints":
            self = .pt
        case "fl", "fls", "floz", "flozs", "fl oz", "fl ozs", "fl. oz", "fl. ozs", "fluid oz", "fluid ozs", "fluid ounce", "fluid ounces":
            self = .fl
        case "c", "cs", "cup", "cups", "cupdry":
            self = .cupDry
        case "cupwet":
            self = .cupWet
        case "m", "ms", "metre", "metres", "meter", "meters":
            self = .m
        case "cm", "cms", "centimetre", "centimetres", "centimeter", "centimeters":
            self = .cm
        case "mm", "mms", "millimetre", "millimetres", "millimeter", "millimeters":
            self = .mm
        case "yd", "yds", "yard", "yards":
            self = .yd
        case "ft", "foot", "feet":
            self = .ft
        case "in", "ins", "inch", "inches":
            self = .in
        case "tsp", "tsps", "teaspoon", "teaspoons", "tea-spoon", "tea-spoons":
            self = .tsp
        case "tbsp", "tbsps", "tablespoon", "tablespoons", "table-spoon", "table-spoons":
            self = .tbsp
        case "serving", "servings":
            self = .serving
        case "slice", "slices":
            self = .slice
        default:
            self = .none
        }
    }
    
    func _longName(for quantity: Double) -> String? {
        if case .none = self {
            return nil
        }
        if shouldShowSingular(quantity) {
            return localized
        }
        return NSLocalizedString("Units_" + rawValue + "_plural", bundle: .module, comment: rawValue)
    }
    
    var _longName: String? {
        if case .none = self {
            return nil
        }
        return localized.capitalized
    }
    
    var _uniqueLongName: String {
        switch self {
        case .cupDry, .cupWet:
            return NSLocalizedString("Units_" + rawValue + "_unique", bundle: .module, comment: rawValue)
        default:
            return NSLocalizedString("Units_" + rawValue + "_plural", bundle: .module, comment: rawValue)
        }
    }
    
    func _shortName(for quantity: Double) -> String? {
        if case .none = self {
            return nil
        }
        if shouldShowSingular(quantity) {
            return shortName
        }
        return NSLocalizedString("Units_" + rawValue + "_short", bundle: .module, comment: rawValue)
    }
    
    var _shortName: String? {
        switch self {
        case .none:
            return nil
        case .fl:
            return NSLocalizedString("Units_fl_oz", bundle: .module, comment: "fl oz")
        case .cupDry, .cupWet:
            return NSLocalizedString("Units_cup", bundle: .module, comment: "cup")
        default:
            return rawValue
        }
    }
    
    func _roundedDisplay(withAmount amount: Double) -> String? {
        // TODO: make this configurable
        guard amount > 0 else {
            return nil
        }
        
        switch decimalPlaces {
        case 0:
            return symbolicated(for: amount) ?? String(Int(amount))
        case 1:
            return symbolicated(for: amount) ?? NumberFormatter.singleDecimalPlaceFormatter.string(from: NSNumber(value: amount))!
        case 2:
            return symbolicated(for: amount) ?? NumberFormatter.twoDecimalPlacesFormatter.string(from: NSNumber(value: amount))!
        default:
            return symbolicated(for: amount) ?? String(Int(amount))
        }
    }
    
    func _shortDisplay(withAmount amount: Double?) -> String? {
        
        guard let amount = amount else {
            return nil
        }
        
        switch self {
        case .yd:
            
            let yards = floor(amount)
            let feet = floor(_convert(amount, to: .ft)!.truncatingRemainder(dividingBy: 3))
            var inches = _convert(amount, to: .in)!.truncatingRemainder(dividingBy: 36)
            if yards > 0 || feet > 0 {
                inches = floor(inches)
            }
             
            let yardsElement = yards > 0 ? "\(Int(yards)) \(_shortName(for: yards)!) " : ""
            let feetElement = feet > 0 ? "\(Int(feet)) \(UnitSystem.Unit.ft._shortName(for: feet)!) " : ""
            let inchesElement = inches > 0 ? "\(UnitSystem.Unit.in._roundedDisplay(withAmount: inches)!) \(UnitSystem.Unit.in._shortName(for: inches)!) " : ""
            
            return "\(yardsElement)\(feetElement)\(inchesElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .ft:
            
            let feet = floor(amount)
            var inches = _convert(amount, to: .in)!.truncatingRemainder(dividingBy: 12)
            if feet > 0 {
                inches = floor(inches)
            }
            
            let feetElement = feet > 0 ? "\(Int(feet)) \(_shortName(for: feet)!) " : ""
            let inchesElement = inches > 0 ? "\(UnitSystem.Unit.in._roundedDisplay(withAmount: inches)!) \(UnitSystem.Unit.in._shortName(for: inches)!) " : ""
            
            return "\(feetElement)\(inchesElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .pt:
            
            let isUS = Locale.isUS
            
            let pints = floor(amount)
            var floz = _convert(amount, to: .fl)!.truncatingRemainder(dividingBy: isUS ? 16 : 20)
            if pints > 0 {
                floz = floor(floz)
            }
            
            let pintsElement = pints > 0 ? "\(Int(pints)) \(_shortName(for: pints)!) " : ""
            let flozElement = floz > 0 ? "\(UnitSystem.Unit.fl._roundedDisplay(withAmount: floz)!) \(UnitSystem.Unit.fl._shortName(for: floz)!) " : ""
            
            return "\(pintsElement)\(flozElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .lb:
            
            let pounds = floor(amount)
            var oz = _convert(amount, to: .oz)!.truncatingRemainder(dividingBy: 16)
            if pounds > 0 {
                oz = floor(oz)
            }
            
            let poundsElement = pounds > 0 ? "\(Int(pounds)) \(_shortName(for: pounds)!) " : ""
            let ozElement = oz > 0 ? "\(UnitSystem.Unit.oz._roundedDisplay(withAmount: oz)!) \(UnitSystem.Unit.oz._shortName(for: oz)!) " : ""
            
            return "\(poundsElement)\(ozElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        default:
            break
        }
        
        guard let amountResult = _roundedDisplay(withAmount: amount) else {
            return nil
        }
        
        if let unitName = _shortName(for: amount) {
            return "\(amountResult) \(unitName)"
        }
        
        return amount > 0 ? amountResult : nil
    }
    
    func _longDisplay(withAmount amount: Double?) -> String? {
        
        guard let amount = amount else {
            return nil
        }
        
        switch self {
        case .yd:
            
            let yards = floor(amount)
            let feet = _convert(amount, to: .ft)!.truncatingRemainder(dividingBy: 3)
            var inches = _convert(amount, to: .in)!.truncatingRemainder(dividingBy: 36)
            if yards > 0 || feet > 0 {
                inches = floor(inches)
            }
             
            let yardsElement = yards > 0 ? "\(Int(yards)) \(_longName(for: yards)!) " : ""
            let feetElement = feet > 0 ? "\(Int(feet)) \(UnitSystem.Unit.ft._longName(for: feet)!) " : ""
            let inchesElement = inches > 0 ? "\(UnitSystem.Unit.in._roundedDisplay(withAmount: inches)!) \(UnitSystem.Unit.in._longName(for: inches)!) " : ""
            
            return "\(yardsElement)\(feetElement)\(inchesElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .ft:
            
            let feet = floor(amount)
            var inches = _convert(amount, to: .in)!.truncatingRemainder(dividingBy: 12)
            if feet > 0 {
                inches = floor(inches)
            }
            
            let feetElement = feet > 0 ? "\(Int(feet)) \(_longName(for: feet)!) " : ""
            let inchesElement = inches > 0 ? "\(UnitSystem.Unit.in._roundedDisplay(withAmount: inches)!) \(UnitSystem.Unit.in._longName(for: inches)!) " : ""
            
            return "\(feetElement)\(inchesElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .pt:
            
            let isUS = Locale.isUS
            
            let pints = floor(amount)
            var floz = _convert(amount, to: .fl)!.truncatingRemainder(dividingBy: isUS ? 16 : 20)
            if pints > 0 {
                floz = floor(floz)
            }
            
            let pintsElement = pints > 0 ? "\(Int(pints)) \(_longName(for: pints)!) " : ""
            let flozElement = floz > 0 ? "\(UnitSystem.Unit.fl._roundedDisplay(withAmount: floz)!) \(UnitSystem.Unit.fl._longName(for: floz)!) " : ""
            
            return "\(pintsElement)\(flozElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .lb:
            
            let pounds = floor(amount)
            var oz = _convert(amount, to: .oz)!.truncatingRemainder(dividingBy: 16)
            if pounds > 0 {
                oz = floor(oz)
            }
            
            let poundsElement = pounds > 0 ? "\(Int(pounds)) \(_longName(for: pounds)!) " : ""
            let ozElement = oz > 0 ? "\(UnitSystem.Unit.oz._roundedDisplay(withAmount: oz)!) \(UnitSystem.Unit.oz._longName(for: oz)!) " : ""
            
            return "\(poundsElement)\(ozElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        default:
            break
        }
        
        guard let amountResult = _roundedDisplay(withAmount: amount) else {
            return nil
        }
        
        if let unitName = _longName(for: amount) {
            return "\(amountResult) \(unitName)"
        }
        
        return amount > 0 ? amountResult : nil
    }
    
    var _importOptions: [ImportOption] {
        switch self {
        case .cupDry, .cupWet:
            
            let options: [ImportOption] = [
                ImportOption(title: UnitSystem.Unit.cupDry.importOptionTitle, unit: .cupDry),
                ImportOption(title: UnitSystem.Unit.cupWet.importOptionTitle, unit: .cupWet)
            ]
            
            return options
            
        default:
            return []
        }
    }
    
    var _importWarning: String? {
        switch self {
        case .cupDry, .cupWet:
            return NSLocalizedString("Units_importWarning_cups", bundle: .module, comment: "Cup type import warning")
        default:
            return nil
        }
    }
    
    var _conversionOptions: [UnitSystem.Unit] {
        switch self {
        case .none, .serving, .tsp, .tbsp, .slice: return []
        case .kg: return [.g, .lb, .oz, .cupDry]
        case .g: return [.kg, .lb, .oz, .cupDry]
        case .lb: return [.kg, .g, .oz, .cupDry]
        case .oz: return [.kg, .g, .lb, .cupDry]
        case .ltr: return [.ml, .pt, .fl, .cupWet]
        case .ml: return [.ltr, .pt, .fl, .cupWet]
        case .pt: return [.ltr, .ml, .fl, .cupWet]
        case .fl: return [.ltr, .ml, .pt, .cupWet]
        case .cupDry: return [.kg, .g, .lb, .oz]
        case .cupWet: return [.ltr, .ml, .pt, .fl]
        case .m: return [.cm, .mm, .yd, .ft, .in]
        case .cm: return [.m, .mm, .yd, .ft, .in]
        case .mm: return [.m, .cm, .yd, .ft, .in]
        case .yd: return [.m, .cm, .mm, .ft, .in]
        case .ft: return [.m, .cm, .mm, .yd, .in]
        case .in: return [.m, .cm, .mm, .yd, .ft]
        }
    }
    
    func _conversionWarning(whenConvertingTo to: UnitSystem.Unit) -> String? {
        
        switch (self, to) {
        case (.kg, .cupDry), (.g, .cupDry), (.lb, .cupDry), (.oz, .cupDry):
            return NSLocalizedString("Units_conversionWarning_toCupsDry", bundle: .module, comment: "Dry conversion warning")
        case (.cupDry, .kg), (.cupDry, .g), (.cupDry, .lb), (.cupDry, .oz):
            return NSLocalizedString("Units_conversionWarning_toCupsDry", bundle: .module, comment: "Dry conversion warning")
        default:
            return nil
        }
    }
    
    func _toMetric(_ amount: Double) -> (unit: UnitSystem.Unit, amount: Double) {
        
        let isUS = Locale.isUS
        
        switch self {
        case .tsp, .tbsp, .slice, .serving, .none:
            return (self, amount)
        case .cupWet:
            guard !isUS else {
                return (self, amount)
            }
            return convertToLitres(amount)
        case .cupDry:
            guard !isUS else {
                return (self, amount)
            }
            return convertToKilos(amount)
        case .kg, .g, .lb, .oz:
            return convertToKilos(amount)
        case .ltr, .ml, .pt, .fl:
            return convertToLitres(amount)
        case .m, .cm, .mm, .yd, .ft, .in:
            return convertToMetres(amount)
        }
    }
    
    func _toImperial(_ amount: Double) -> (unit: UnitSystem.Unit, amount: Double) {
        
        let isUS = Locale.isUS
        
        switch self {
        case .tsp, .tbsp, .slice, .serving, .none:
            return (self, amount)
        case .cupWet:
            guard !isUS else {
                return (self, amount)
            }
            return convertToPints(amount)
        case .cupDry:
            guard !isUS else {
                return (self, amount)
            }
            return convertToPounds(amount)
        case .lb, .oz, .kg, .g:
            return convertToPounds(amount)
        case .pt, .fl, .ltr, .ml:
            return convertToPints(amount)
        case .yd, .ft, .in, .m, .cm, .mm:
            return convertToYards(amount)
        }
    }
    
    func _convert(_ amount: Double, to: UnitSystem.Unit) -> Double? {
        
        let isUS = Locale.isUS
        let factor: Double?
        
        switch (self, to) {
        // Dry
        case (.kg, .kg): factor = 1
        case (.kg, .g): factor = 1000
        case (.g, .kg): factor = 0.001
        case (.kg, .lb): factor = 2.20462
        case (.lb, .kg): factor = 0.45359
        case (.kg, .oz): factor = 35.27392
        case (.oz, .kg): factor = 0.02835
        case (.g, .g): factor = 1
        case (.g, .lb): factor = 0.00220462
        case (.lb, .g): factor = 454.592
        case (.g, .oz): factor = 0.03527392
        case (.oz, .g): factor = 28.34955
        case (.lb, .lb): factor = 1
        case (.lb, .oz): factor = 16
        case (.oz, .lb): factor = 0.0625
        case (.oz, .oz): factor = 1
        case (.cupDry, .cupDry): factor = 1
        case (.kg, .cupDry): factor = 5
        case (.cupDry, .kg): factor = 0.2
        case (.g, .cupDry): factor = 0.005
        case (.cupDry, .g): factor = 200
        case (.lb, .cupDry): factor = 2.27
        case (.cupDry, .lb): factor = 0.44052
        case (.oz, .cupDry): factor = 0.14188
        case (.cupDry, .oz): factor = 7.05
        // Wet
        case (.ltr, .ltr): factor = 1
        case (.ltr, .ml): factor = 1000
        case (.ml, .ltr): factor = 0.001
        case (.ltr, .pt): factor = isUS ? 2.11416 : 1.76056
        case (.pt, .ltr): factor = isUS ? 0.473 : 0.568
        case (.ltr, .fl): factor = isUS ? 33.82664 : 35.21127
        case (.fl, .ltr): factor = isUS ? 0.02956 : 0.0284
        case (.ml, .ml): factor = 1
        case (.ml, .pt): factor = isUS ? 0.0021141 : 0.0017606
        case (.pt, .ml): factor = isUS ? 473 : 568
        case (.ml, .fl): factor = isUS ? 0.03383 : 0.03521
        case (.fl, .ml): factor = isUS ? 29.5625 : 28.4
        case (.pt, .pt): factor = 1
        case (.pt, .fl): factor = isUS ? 16 : 20
        case (.fl, .pt): factor = isUS ? 0.0625 : 0.05
        case (.fl, .fl): factor = 1
        case (.cupWet, .cupWet): factor = 1
        case (.ltr, .cupWet): factor = isUS ? 4.22676 : 4
        case (.cupWet, .ltr): factor = isUS ? 0.23659 : 0.25
        case (.ml, .cupWet): factor = isUS ? 0.0042267 : 0.004
        case (.cupWet, .ml): factor = isUS ? 236.59 : 250
        case (.pt, .cupWet): factor = isUS ? 2 : 2.272
        case (.cupWet, .pt): factor = isUS ? 0.5 : 0.44014
        case (.fl, .cupWet): factor = isUS ? 0.125 : 0.1136
        case (.cupWet, .fl): factor = isUS ? 8 : 8.8028
        // Distance
        case (.m, .m): factor = 1
        case (.m, .cm): factor = 100
        case (.cm, .m): factor = 0.01
        case (.m, .mm): factor = 1000
        case (.mm, .m): factor = 0.001
        case (.m, .yd): factor = 1.09361
        case (.yd, .m): factor = 0.9144
        case (.m, .ft): factor = 3.28084
        case (.ft, .m): factor = 0.3048
        case (.m, .in): factor = 39.3701
        case (.in, .m): factor = 0.0254
        case (.cm, .cm): factor = 1
        case (.cm, .mm): factor = 10
        case (.mm, .cm): factor = 0.1
        case (.cm, .yd): factor = 0.0109361
        case (.yd, .cm): factor = 91.44028
        case (.cm, .ft): factor = 0.0328084
        case (.ft, .cm): factor = 30.48
        case (.cm, .in): factor = 0.393701
        case (.in, .cm): factor = 2.54
        case (.mm, .mm): factor = 1
        case (.mm, .yd): factor = 0.00109361
        case (.yd, .mm): factor = 914.4
        case (.mm, .ft): factor = 0.003281
        case (.ft, .mm): factor = 304.8
        case (.mm, .in): factor = 0.03937
        case (.in, .mm): factor = 25.4
        case (.yd, .yd): factor = 1
        case (.yd, .ft): factor = 3
        case (.ft, .yd): factor = 0.33333
        case (.yd, .in): factor = 36
        case (.in, .yd): factor = 0.02778
        case (.ft, .ft): factor = 1
        case (.ft, .in): factor = 12
        case (.in, .ft): factor = 0.08333
        case (.in, .in): factor = 1
        default:
            factor = nil
        }
        
        guard let conversionFactor = factor else {
            return nil
        }
        
        return amount * conversionFactor
    }
}
