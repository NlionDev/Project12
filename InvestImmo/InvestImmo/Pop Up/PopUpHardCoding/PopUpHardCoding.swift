//
//  PopUpHardCoding.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 17/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation

//MARK: - Properties
let existantProjectCellIdentifier = "ExistantProjectAlertCell"
let newProjectVCIdentifier = "EmptyNewProjectAlertVC"
let commaString = ", "

//MARK: - Enum
enum PopUpAlertMessage {
    case projectAlreadyExist
    case projectNameMissing
    case adressMissing
    case postalCodeMissing
    case cityMissing
    
    var message: String {
        switch self {
        case .projectAlreadyExist:
            return "Un projet existant porte déjà ce nom."
        case .projectNameMissing:
            return "Vous n'avez pas entré de nom pour ce projet."
        case .adressMissing:
            return "Vous n'avez pas rempli le champ 'Adresse'."
        case .postalCodeMissing:
            return "Vous n'avez pas rempli le champ 'Code Postal'."
        case .cityMissing:
            return "Vous n'avez pas rempli le champ 'Ville'."
        }
    }
}
enum PopUpNotification {
    case dismissFromPrevious
    case dismissFromReplace
    case reloadSavedProjects
    case configureMapView
    case dismissFisrtAlert
    
    var name: String {
        switch self {
        case .dismissFromPrevious:
            return "DismissPreviousAlert"
        case .dismissFromReplace:
            return "DismissAlertFromReplaceVC"
        case .reloadSavedProjects:
            return "ReloadSavedProjectsData"
        case .configureMapView:
            return "ConfigureMapView"
        case .dismissFisrtAlert:
            return "DismissFirstAlert"
        }
    }
}

enum SimulationsVC {
    case rentabilityNewProject
    case rentabilityExistantProject
    case rentabilityReplaceProject
    case creditNewProject
    case creditExistantProject
    case creditReplaceProject
    
    var identifier: String {
        switch self {
        case .rentabilityNewProject:
            return "RentabilityNewProjectAlertVC"
        case .rentabilityExistantProject:
            return "RentabilityExistantProjectAlertVC"
        case .rentabilityReplaceProject:
            return "ReplaceRentabilityAlertVC"
        case .creditNewProject:
            return "CreditNewProjectAlertVC"
        case .creditExistantProject:
            return "CreditExistantProjectAlertVC"
        case .creditReplaceProject:
            return "ReplaceCreditAlertVC"
        }
    }
}

enum ChecklistVC {
    case checklistNewProject
    case checklistExistantProject
    case checklistReplaceProject
    
    var identifier: String {
        switch self {
        case .checklistNewProject:
            return "ChecklistNewProjectAlertVC"
        case .checklistExistantProject:
            return "ChecklistExistantProjectAlertVC"
        case .checklistReplaceProject:
            return "ReplaceChecklistAlertVC"
        }
    }
}

enum MapVC {
    case mapNewProject
    case mapExistantProject
    case mapReplaceProject
    case mapSearchAdress
    
    var identifier: String {
        switch self {
        case .mapNewProject:
            return "MapNewProjectAlertVC"
        case .mapExistantProject:
            return "MapExistantProjectAlertVC"
        case .mapReplaceProject:
            return "ReplaceAdressAlertVC"
        case .mapSearchAdress:
            return "SearchAdressVC"
        }
    }
}

enum StoryboardIdentifier {
    case simulations
    case checklist
    case savedProjects
    case map
    
    var identifier: String {
        switch self {
        case .simulations:
            return "SimulationsPopUpStoryboard"
        case .checklist:
            return "ChecklistPopUpStoryboard"
        case .savedProjects:
            return "NewProjectStoryboard"
        case .map:
            return "MapPopUpStoryboard"
        }
    }
}
