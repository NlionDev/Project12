//
//  CreditEnums.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 15/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation

enum CreditCellType {
    case textField
    case pickerView
    case stepper
}

enum CreditItem {
    case amountToFinance
    case duration
    case rate
    case insuranceRate
    case bookingFees
    
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
    
    var subtitles: String {
        switch self {
        case .duration:
            return "( Années )"
        case .rate, .insuranceRate:
            return "%"
        default:
            return ""
        }
    }
    
    var unit: String {
        switch self {
        case .amountToFinance, .bookingFees:
            return "€"
        default:
            return ""
        }
    }
    
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
