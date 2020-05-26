//
//  SimulationsEnums.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 11/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

//MARK: - Properties

/// Property for store euros unit
let eurosUnit = " €"

/// Property for store percent unit
let percentUnit = " %"

/// property to store years unit
let yearsUnit = " ans"

/// Property to store the number of result cell row
let resultCellRowInSection = 4

/// Property to store number of  months for calcul
let numberOfMonths: Double = 12

/// Property to store zero for calcul
let zero: Double = 0.00

/// Property to store hundred for calcul
let hundred: Double = 100

/// Property to store one for calcul
let one: Double = 1

//MARK: - Enums

/// Enumeration for menu bar items
enum MenuBarItems {
    case credit
    case rentability
    
    /// Items titles
    var titles: String {
        switch self {
        case .credit:
            return "Crédit"
        case .rentability:
            return "Rentabilité"
        }
    }
}

/// Enumeration for different simulations storyboard
enum SimulationsStoryboard {
    case storyboard
    case creditVC
    case rentabilityVC
    
    /// Storyboard identifiers
    var identifiers: String {
        switch self {
        case .storyboard:
            return "SimulationsStoryboard"
        case .creditVC:
            return "CreditSimulationVC"
        case .rentabilityVC:
            return "RentabilitySimulationVC"
        }
    }
}

/// Enumeration for simulations cells
enum SimulationsCells {
    case menuBar
    case textFieldWithoutSubtitle
    case textFieldWithSubtitle
    case pickerView
    case stepper
    case result
    
    /// Cells names
    var name: String {
        switch self {
        case .menuBar:
            return ""
        case .textFieldWithoutSubtitle:
            return "TextFieldWithoutSubtitleTableViewCell"
        case .textFieldWithSubtitle:
            return "TextFieldWithSubtitleTableViewCell"
        case .pickerView:
            return "PickerViewTableViewCell"
        case .stepper:
            return "StepperTableViewCell"
        case .result:
            return "ResultTableViewCell"
        }
    }
    
    /// Cells reuse identifiers
    var reuseIdentifier: String {
        switch self {
        case .menuBar:
            return "MenuBarSimulationCell"
        case .textFieldWithoutSubtitle:
            return "TextFieldWithoutSubtitleCell"
        case .textFieldWithSubtitle:
            return "TextFieldWithSubtitleCell"
        case .pickerView:
            return "PickerCell"
        case .stepper:
            return "StepperCell"
        case .result:
            return "ResultCell"
        }
    }
}

/// Enumeration for simulations segue
enum SimulationsSegue {
    case credit
    case rentability
    
    /// Segue identifiers
    var identifier: String {
        switch self {
        case .credit:
            return "GoToCreditResults"
        case .rentability:
            return "GoToRentabilityResults"
        }
    }
}


