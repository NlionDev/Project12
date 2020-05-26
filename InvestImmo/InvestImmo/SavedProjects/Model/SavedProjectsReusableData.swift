//
//  SavedProjectsHardCoding.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 15/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

//MARK: - Properties

/// Identifier of saved projects storyboard
let savedProjectsStoryboardIdentifier = "SavedProjectsDataStoryboard"

/// Message for Unauthorize To Pick Photo alert
let unauthorizeToPickPhotoMessageAlert = "Invest'Immo a besoin d'avoir accès à votre bibliothèque photo. Sans ça vous ne pourrez pas choisir des photos de votre bibliothèque. S'il vous plait allez dans vos réglages et autorisez l'accès."

/// Message for duplicate photo alert
let duplicatePhotoAlertMessage = "Cette photo a déjà été ajoutée à la gallerie de ce projet."

//MARK: - Enums

/// Enumeration for Saved projects segue
enum SavedProjectsSegue {
    case details
    case photos
    
    /// Segue identifiers
    var identifier: String {
        switch self {
        case .details:
            return "GoToDetails"
        case .photos:
            return "ShowSelectedPhoto"
        }
    }
}

/// Enumeration for saved projects notifications
enum SavedProjectsNotification {
    case projectsTableView
    case photoCollectionView
    
    /// Notifications names
    var name: String {
        switch self {
        case .projectsTableView:
            return "ReloadSavedProjectsData"
        case .photoCollectionView:
            return "ReloadPhotoCollectionView"
        }
    }
}

/// Enumeration for saved projects cells
enum SavedProjectsCell {
    case project
    case menuBar
    case simulation
    case textView
    case photo
    
    /// Cells names
    var name: String {
        switch self {
        case .project:
            return ""
        case .menuBar:
            return ""
        case .simulation:
            return "DetailsSimulationTableViewCell"
        case .textView:
            return "SavedTextViewTableViewCell"
        case .photo:
            return "PhotoCollectionViewCell"
        }
    }
    
    /// Cells identifiers
    var reuseIdentifier: String {
        switch self {
        case .project:
            return "ProjectCell"
        case .menuBar:
            return "MenuBarCell"
        case .simulation:
            return "DetailsSimulationCell"
        case .textView:
            return "SavedTextViewCell"
        case .photo:
            return "PhotoCell"
        }
    }
}

/// Enumeration for menu bar items
enum MenuBarItemsNames {
    case euro
    case ratio
    case checklist
    case gallery
    case map
    
    /// Items names
    var name: String {
        switch self {
        case .euro:
            return "euroIcon"
        case .ratio:
            return "ratioIcon"
        case .checklist:
            return "checklistIcon"
        case .gallery:
            return "galleryIcon"
        case .map:
            return "mapIcon"
        }
    }
}

/// Enumeration for saved projects viewControllers
enum SavedProjectsVC {
    case credit
    case rentability
    case checklist
    case gallery
    case map
    
    /// ViewControllers identifiers
    var identifier: String {
        switch self {
        case .credit:
            return "CreditData"
        case .rentability:
            return "RentabilityData"
        case .checklist:
            return "ChecklistData"
        case .gallery:
            return "SavedPhotos"
        case .map:
            return "Map"
        }
    }
}
