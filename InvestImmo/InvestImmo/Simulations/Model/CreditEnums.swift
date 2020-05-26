//
//  CreditEnums.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 15/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation

/// Enumeration for credit cells type
enum CreditCellType {
    case textField
    case pickerView
    case stepper
}

/// Enumeration for credit items
enum CreditItem {
    case amountToFinance
    case duration
    case rate
    case insuranceRate
    case bookingFees
    
    /// Items titles
    var titles: String {
        switch self {
        case .amountToFinance:
            return "Montant à financer"
        case .duration:
            return "Durée"
        case .rate:
            return "Taux"
        case .insuranceRate:
            return "Taux assurance"
        case .bookingFees:
            return "Frais de dossier"
        }
    }
    
    /// Items subtitles
    var subtitles: String {
        switch self {
        case .duration:
            return "(Années)"
        case .rate, .insuranceRate:
            return "%"
        default:
            return ""
        }
    }
    
    /// Items unit
    var unit: String {
        switch self {
        case .amountToFinance, .bookingFees:
            return "€"
        default:
            return ""
        }
    }
    
    /// Items cell type
    var cellType: CreditCellType {
        switch self {
        case .amountToFinance, .bookingFees:
            return .textField
        case .duration:
            return .pickerView
        case .rate, .insuranceRate:
            return .stepper
        }
    }
}

typealias CreditCells = [CreditItem]

/// Enumeration for credit result items
enum CreditResultItem {
    case mensuality
    case interestCost
    case insuranceCost
    case totalCost
    
    /// Items titles
    var titles: String {
        switch self {
        case .mensuality:
            return "Mensualités"
        case .interestCost:
            return "Coût intérêts"
        case .insuranceCost:
            return "Coût assurance"
        case .totalCost:
            return "Coût total"
        }
    }
    
    /// Items index
    var index: Int {
        switch self {
        case .mensuality:
            return 0
        case .interestCost:
            return 1
        case .insuranceCost:
            return 2
        case .totalCost:
            return 3
        }
    }
}
