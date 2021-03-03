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
            let feet = max(floor(_convert(amount, to: .ft)!) - yards * 3, 0) // because truncatingRemainder doesn't work when the amount is a tiny fraction less than a whole number
            var inches = max(_convert(amount, to: .in)! - yards * 36, 0)
            if yards > 0 || feet > 0 {
                inches = floor(inches)
            }
             
            let yardsElement = yards > 0 ? "\(Int(yards)) \(_shortName(for: yards)!) " : ""
            let feetElement = feet > 0 ? "\(Int(feet)) \(UnitSystem.Unit.ft._shortName(for: feet)!) " : ""
            let inchesElement = inches > 0 ? "\(UnitSystem.Unit.in._roundedDisplay(withAmount: inches)!) \(UnitSystem.Unit.in._shortName(for: inches)!) " : ""
            
            return "\(yardsElement)\(feetElement)\(inchesElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .ft:
            
            let feet = floor(amount)
            var inches = max(_convert(amount, to: .in)! - feet * 12, 0) // because truncatingRemainder doesn't work when the amount is a tiny fraction less than a whole number
            if feet > 0 {
                inches = floor(inches)
            }
            
            let feetElement = feet > 0 ? "\(Int(feet)) \(_shortName(for: feet)!) " : ""
            let inchesElement = inches > 0 ? "\(UnitSystem.Unit.in._roundedDisplay(withAmount: inches)!) \(UnitSystem.Unit.in._shortName(for: inches)!) " : ""
            
            return "\(feetElement)\(inchesElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .pt:
            
            let isUS = Locale.isUS
            
            let pints = floor(amount)
            var floz = max(_convert(amount, to: .fl)! - pints * (isUS ? 16 : 20), 0) // because truncatingRemainder doesn't work when the amount is a tiny fraction less than a whole number
            if pints > 0 {
                floz = floor(floz)
            }
            
            let pintsElement = pints > 0 ? "\(Int(pints)) \(_shortName(for: pints)!) " : ""
            let flozElement = floz > 0 ? "\(UnitSystem.Unit.fl._roundedDisplay(withAmount: floz)!) \(UnitSystem.Unit.fl._shortName(for: floz)!) " : ""
            
            return "\(pintsElement)\(flozElement)".trimmingCharacters(in: .whitespacesAndNewlines)
            
        case .lb:
            
            let pounds = floor(amount)
            var oz = max(_convert(amount, to: .oz)! - pounds * 16, 0) // because truncatingRemainder doesn't work when the amount is a tiny fraction less than a whole number
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
    
    func _mainUnit(for system: UnitSystem = .default) -> UnitSystem.Unit? {
        
        let isMetric = system == .metric
        
        switch unitType {
        case .weight:
            return isMetric ? .kg : .lb
        case .volume:
            return isMetric ? .ltr : .pt
        case .distance:
            return isMetric ? .m : .yd
        case .misc, .none:
            return nil
        }
    }
    
    var _conversionOptions: [UnitSystem.Unit] {
        
        var units = allConversionOptions
        units.removeAll { $0 == self }
        
        return units
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
        
        switch self {
        case .cupWet, .cupDry:
            if Locale.isUS {
                return (self, amount)
            }
        default:
            break
        }
        
        switch unitType {
        case .misc, .none:
            return (self, amount)
        case .weight:
            return convertToKilos(amount)
        case .volume:
            return convertToLitres(amount)
        case .distance:
            return convertToMetres(amount)
        }
    }
    
    func _toImperial(_ amount: Double) -> (unit: UnitSystem.Unit, amount: Double) {
        
        switch self {
        case .cupWet, .cupDry:
            if Locale.isUS {
                return (self, amount)
            }
        default:
            break
        }
        
        switch unitType {
        case .misc, .none:
            return (self, amount)
        case .weight:
            return convertToPounds(amount)
        case .volume:
            return convertToPints(amount)
        case .distance:
            return convertToYards(amount)
        }
    }
    
    func _convert(_ amount: Double, to: UnitSystem.Unit) -> Double? {
        
        guard allConversionOptions.contains(to) else {
            return nil
        }
        
        return amount * value / to.value
    }
}
