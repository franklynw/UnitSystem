//
//  File.swift
//  
//
//  Created by Franklyn Weber on 31/03/2021.
//

import Foundation


extension UnitSystem.Unit: Codable {
    
    public init(rawValue: String) {

        // TODO: - localise

        switch rawValue.lowercased() {
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
}
