//
//  PopUpHardCoding.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 17/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation

//MARK: - Properties

/// Identifier of existant project cell
let existantProjectCellIdentifier = "ExistantProjectAlertCell"

/// Identifier of new project alert viewcontroller
let newProjectVCIdentifier = "EmptyNewProjectAlertVC"

/// Property for store comma
let commaString = ", "

//MARK: - Enum

/// Enumeration of pop up alert
enum PopUpAlertMessage {
    case projectAlreadyExist
    case projectNameMissing
    case adressMissing
    case postalCodeMissing
    case cityMissing
    
    /// Pop up messages
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

///Enumeration of pop up notification
enum PopUpNotification {
    case dismissFromPrevious
    case dismissFromReplace
    case reloadSavedProjects
    case configureMapView
    case dismissFisrtAlert
    
    /// Notification names
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

/// Enumeration of simulations viewcontroller
enum SimulationsVC {
    case rentabilityNewProject
    case rentabilityExistantProject
    case rentabilityReplaceProject
    case creditNewProject
    case creditExistantProject
    case creditReplaceProject
    
    /// ViewControllers identifiers
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

/// Enumeration of checklist viewControllers
enum ChecklistVC {
    case checklistNewProject
    case checklistExistantProject
    case checklistReplaceProject
    
    /// ViewControllers identifiers
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

/// Enumeration of Map ViewControllers
enum MapVC {
    case mapNewProject
    case mapExistantProject
    case mapReplaceProject
    case mapSearchAdress
    
    /// ViewControllers Identifiers
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

/// Enumeration of Storyboard
enum StoryboardIdentifier {
    case simulations
    case checklist
    case savedProjects
    case map
    
    /// Storyboard identifiers
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
