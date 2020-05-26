//
//  Enums.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 15/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation

/// Enumeration of rentabilty cells type
enum RentabilityCellType {
    case textFieldWithSubtitles
    case textFieldWithoutSubtitles
}

/// Enumeration of rentability items
enum RentabilityItem {
    case estatePrice
    case worksCost
    case notaryFees
    case monthlyRent
    case propertyTax
    case maintenanceFees
    case charges
    case managementFees
    case insurance
    case creditCost
    
    /// Items titles
    var titles: String {
        switch self {
        case .estatePrice:
            return "Prix du bien"
        case .worksCost:
            return "Coût des travaux"
        case .notaryFees:
            return "Frais de notaire"
        case .monthlyRent:
            return "Loyer mensuel"
        case .propertyTax:
            return "Taxe foncière"
        case .maintenanceFees:
            return "Frais d'entretien"
        case .charges:
            return "Charges de copropriété"
        case .managementFees:
            return "Frais de gérance"
        case .insurance:
            return "Assurance loyers impayés"
        case .creditCost:
            return "Coût du crédit"
        }
    }
    
    /// Items subtitles
    var subtitles: String {
        switch self {
        case .monthlyRent:
            return "(Hors Charges)"
        case .propertyTax:
            return "(Annuelle)"
        case .maintenanceFees:
            return "(Annuels)"
        case .charges:
            return "(Annuelles)"
        case .insurance:
            return "(Mensuelle)"
        case .creditCost:
            return "(Mensuel)"
        default:
            return ""
        }
    }
    
    /// Items unit
    var unit: String {
        switch self {
        case .managementFees:
            return "%"
        default:
            return "€"
        }
    }
    
    /// Items cell type
    var cellType: RentabilityCellType {
        switch self {
        case .estatePrice, .worksCost, .notaryFees, .managementFees:
            return .textFieldWithoutSubtitles
        case .monthlyRent, .propertyTax, .maintenanceFees, .charges, .insurance, .creditCost:
            return .textFieldWithSubtitles
        }
    }
}

typealias RentabilityCells = [RentabilityItem]

/// Enumeration of rentability result items
enum RentabilityResultItem {
    case grossYield
    case netYield
    case annualCashflow
    case mensualCashflow
    
    /// Items titles
    var titles: String {
        switch self {
        case .grossYield:
            return "Rendement Brut"
        case .netYield:
            return "Rendement Net"
        case .annualCashflow:
            return "Cash-Flow Annuel"
        case .mensualCashflow:
            return  "Cash-Flow Mensuel"
        }
    }
    
    /// Items index
    var index: Int {
        switch self {
        case .grossYield:
            return 0
        case .netYield:
            return 1
        case .annualCashflow:
            return 2
        case .mensualCashflow:
            return 3
        }
    }
}
