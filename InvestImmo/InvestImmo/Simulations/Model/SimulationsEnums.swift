//
//  SimulationsEnums.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 11/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

enum MenuBarItems {
    case credit
    case rentability
    
    var titles: String {
        switch self {
        case .credit:
            return "Crédit"
        case .rentability:
            return "Rentabilité"
        }
    }
}

enum SimulationsStoryboard {
    case storyboard
    case creditVC
    case rentabilityVC
    
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


enum SimulationsCells {
    case menuBar
    case textFieldWithoutSubtitle
    case textFieldWithSubtitle
    case pickerView
    case stepper
    case result
    
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

enum SimulationsSegue {
    case credit
    case rentability
    
    var identifier: String {
        switch self {
        case .credit:
            return "GoToCreditResults"
        case .rentability:
            return "GoToRentabilityResults"
        }
    }
}


