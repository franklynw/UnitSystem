//
//  UnitSystem+Public.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension UnitSystem {
    
    /// Returns a unit system based on whether the current locale uses Metric or not
    public static var `default`: UnitSystem {
        return Locale.current.usesMetricSystem ? .metric : .imperial
    }
    
    /// The localised name of the unit system
    public var name: String {
        return localized
    }
    
    /// Returns an array of units for the receiver
    public var units: [UnitSystem.Unit] {
        switch self {
        case .imperial: return [.none, .lb, .oz, .pt, .fl, .cupDry, .cupWet, .slice, .yd, .ft, .in]
        case .metric: return [.none, .kg, .g, .ltr, .ml, .cupDry, .cupWet, .slice, .m, .cm, .mm]
        case .all: return [.none, .kg, .g, .lb, .oz, .ltr, .ml, .pt, .fl, .cupDry, .cupWet, .slice, .m, .cm, .mm, .yd, .ft, .in]
        }
    }
    
    /// Returns an array of available conversion options for the specified unit in the unit system
    /// - Parameter unit: the unit which we want conversion options for
    /// - Returns: an array of units
    public func conversionOptions(for unit: UnitSystem.Unit) -> [UnitSystem.Unit] {
        return unit.conversionOptions.filter { units.contains($0) }
    }
}
