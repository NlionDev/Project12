//
//  MapHardCoding.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 15/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation

//MARK: - Properties

/// Waze begin of url
let wazeBeginUrl = "waze://"

/// Waze app url
let wazeAppUrl = "waze://?ll=%f,%f&navigate=yes"

/// Waze itunes url
let wazeItunesUrl = "http://itunes.apple.com/us/app/id323229106"

/// Identifier of Project Map Annoration
let projectMapAnnotationIdentifier = "pma"

/// Name of Map Notification
let mapNotificationName = "ConfigureMapView"

//MARK: - Enums

/// Enumeration of map alert
enum MapAlert {
    case waze
    case plan
    case cancel
    case Unauthorize
    case adressMissing
    case incorrectAdress
    
    /// Map Alert messages
    var message: String {
        switch self {
        case .waze:
            return "Waze"
        case .plan:
            return "Plan"
        case .cancel:
            return "Annuler"
        case .Unauthorize:
            return "Invest'Immo ne pourra pas mettre à jour votre position sur la carte sans avoir accès à votre localisation."
        case .adressMissing:
            return "Vous devez d'abord rechercher une adresse avant de pouvoir l'ajouter."
        case .incorrectAdress:
            return "L'adresse entrée est incorrect et ne peut pas être trouvée."
        }
    }
}
