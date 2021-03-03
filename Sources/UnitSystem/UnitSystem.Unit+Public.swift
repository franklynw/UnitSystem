//
//  UnitSystem.Unit+Public.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import Foundation


extension UnitSystem.Unit {
    
    /// Initialiser which will attempt to initialise a Unit based on a string representation
    /// Will default to .none if there are no matches
    /// - Parameter candidate: a String
    public init(candidate: String) {
        self.init(candidate)
    }
    
    /// The unit's long name, depending on the quantity
    /// - Parameter quantity: the number of units
    /// - Returns: either a singular or plural version of the unit's long name
    public func longName(for quantity: Double) -> String? {
        return _longName(for: quantity)
    }
    
    /// The unit's singular long name
    public var longName: String? {
        return _longName
    }
    
    /// A long name which is guaranteed to be unique for each case
    public var uniqueLongName: String {
        return _uniqueLongName
    }
    
    /// The unit's short name, depending on the quantity
    /// - Parameter quantity: the number of units
    /// - Returns: either a singular or plural version of the unit's short name
    public func shortName(for quantity: Double) -> String? {
        return _shortName(for: quantity)
    }
    
    /// The unit's singular short name
    public var shortName: String? {
        return _shortName
    }
    
    /// The amount formatted with the correct number of decimal places for the type of unit
    /// - Parameter amount: the amount of the unit
    /// - Returns: a String
    public func roundedDisplay(withAmount amount: Double) -> String? {
        return _roundedDisplay(withAmount: amount)
    }
    
    /// The combined amount and unit, with the short unit name
    /// - Parameter amount: the quantity of the unit
    /// - Returns: a String description
    public func shortDisplay(withAmount amount: Double?) -> String? {
        return _shortDisplay(withAmount: amount)
    }
    
    /// The combined amount and unit, with the long unit name
    /// - Parameter amount: the quantity of the unit
    /// - Returns: a String description
    public func longDisplay(withAmount amount: Double?) -> String? {
        return _longDisplay(withAmount: amount)
    }
    
    /// Some units are ambiguous when converting from strings - this flags up those which are
    public var importOptions: [ImportOption] {
        return _importOptions
    }
    
    /// An appropriate warning which can be surfaced for ambiguous imports
    public var importWarning: String? {
        return _importWarning
    }
    
    /// The main unit for the unit type, depending on the unit system (eg, returns kg for metric weight)
    public func mainUnit(for system: UnitSystem = .default) -> UnitSystem.Unit? {
        return _mainUnit(for: system)
    }
    
    /// An array of units which the receiver can be converted into
    public var conversionOptions: [UnitSystem.Unit] {
        return _conversionOptions
    }
    
    /// Some units are not possible to convert properly, eg, dry measure cups to weight - this returns an appropriate warning for those cases
    /// - Parameter to: the unit which we want to convert to
    /// - Returns: A warning string
    public func conversionWarning(whenConvertingTo to: UnitSystem.Unit) -> String? {
        return _conversionWarning(whenConvertingTo: to)
    }
    
    /// Will attempt to convert an amount into an appropriate Metric value
    /// - Parameter amount: the amount to convert
    /// - Returns: a Metric conversion - a tuple with the new unit & the amount
    public func toMetric(_ amount: Double) -> (unit: UnitSystem.Unit, amount: Double) {
        return _toMetric(amount)
    }
    
    /// Will attempt to convert an amount into an appropriate Imperial value
    /// - Parameter amount: the amount to convert
    /// - Returns: an Imperial conversion - a tuple with the new unit & the amount
    public func toImperial(_ amount: Double) -> (unit: UnitSystem.Unit, amount: Double) {
        return _toImperial(amount)
    }
    
    /// Attempts to convert an amount from the receiver's unit to another
    /// - Parameters:
    ///   - amount: the amount to convert
    ///   - to: the unit to convert to
    /// - Returns: the converted amount
    public func convert(_ amount: Double, to: UnitSystem.Unit) -> Double? {
        return _convert(amount, to: to)
    }
}
