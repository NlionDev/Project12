//
//  ChecklistEnums.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 15/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//


enum ChecklistCellType {
    case datePicker
    case textView
    case textField
    case segment
    case pickerView
    
    var name: String {
        switch self {
        case .datePicker:
            return "DatePickerTableViewCell"
        case .textView:
            return "TextViewTableViewCell"
        case .textField:
            return "ChecklistTextFieldTableViewCell"
        case .segment:
            return "SegmentTableViewCell"
        case .pickerView:
            return "ChecklistPickerTableViewCell"
        }
    }
    
    var reuseIdentifier: String {
        switch self {
        case .datePicker:
            return "DatePickerCell"
        case .textView:
            return "TextViewCell"
        case .textField:
            return "ChecklistTextFieldCell"
        case .segment:
            return "SegmentCell"
        case .pickerView:
            return "ChecklistPickerCell"
        }
    }
}

enum ChecklistItem {
    case visitDate
    case estateType
    case surfaceArea
    case problem
    case advantage
    case transports
    case easyPark
    case yearOfConstruction
    case numberOfLots
    case internet
    case syndicate
    case facade
    case roof
    case communalAreas
    case dpe
    case light
    case dualAspect
    case vmc
    case humidity
    case heightUnderCeiling
    case planeness
    case insulation
    case soundInsulation
    case direction
    case bedroomView
    case lifeRoomView
    case heatingSystem
    case heatingType
    case electricity
    case electricityMeters
    case toilet
    case bathroom
    case plumbingQuality
    case groundQuality
    case wallQuality
    case shutters
    case doubleGlazing
    case reconfiguration
    case cave
    case caveSurface
    case parking
    case distinguishElements
    
    var titles: String {
        switch self {
        case .visitDate:
            return "Date de la visite"
        case .estateType:
            return "Type de bien"
        case .surfaceArea:
            return "Superficie"
        case .problem:
            return "Nuisances"
        case .advantage:
            return "Atouts"
        case .transports:
            return "Transports"
        case .easyPark:
            return "Stationnement facile"
        case .yearOfConstruction:
            return "Année de construction"
        case .numberOfLots:
            return "Nombre de lots"
        case .internet:
            return "Internet"
        case .syndicate:
            return "Syndicat"
        case .facade:
            return "Qualité façades"
        case .roof:
            return "Qualité toitures"
        case .communalAreas:
            return "Qualité communs"
        case .dpe:
            return "Diagnostic de performances énergétiques"
        case .light:
            return "Lumineux"
        case .dualAspect:
            return "Traversant"
        case .vmc:
            return "VMC"
        case .humidity:
            return "Présence d'humidité"
        case .heightUnderCeiling:
            return "Hauteur sous plafond"
        case .planeness:
            return "Planéité des sols"
        case .insulation:
            return "Isolation"
        case .soundInsulation:
            return "Insonorisation"
        case .direction:
            return "Orientation"
        case .bedroomView:
            return "Vue de la chambre"
        case .lifeRoomView:
            return "Vue de la pièce de vie"
        case .heatingSystem:
            return "Energie du chauffage"
        case .heatingType:
            return "Type de chauffage"
        case .electricity:
            return "Electricité au normes"
        case .electricityMeters:
            return "Compteur individuel"
        case .toilet:
            return "WC isolé"
        case .bathroom:
            return "Salle de bain moderne"
        case .plumbingQuality:
            return "Etat robinetterie"
        case .groundQuality:
            return "Etat des sols"
        case .wallQuality:
            return "Etat des murs"
        case .shutters:
            return "Etat des volets"
        case .doubleGlazing:
            return "Double vitrage"
        case .reconfiguration:
            return "Reconfiguration possible"
        case .cave:
            return "Présence de cave"
        case .caveSurface:
            return "Surface cave"
        case .parking:
            return "Parking"
        case .distinguishElements:
            return "Elements différenciants par rapport aux autres biens"
        }
    }
    
    var unit: String {
        switch self {
        case .surfaceArea, .caveSurface:
            return " m2"
        case .heightUnderCeiling:
            return " cm"
        default:
            return ""
        }
    }
    
    var cellType: ChecklistCellType {
        switch self {
        case .visitDate:
            return .datePicker
        case .problem, .advantage, .transports, .distinguishElements:
            return .textView
        case .estateType, .facade, .roof, .communalAreas, .dpe, .planeness, .insulation, .soundInsulation, .direction, .bedroomView, .lifeRoomView, .heatingSystem, .plumbingQuality, .groundQuality, .wallQuality, .shutters:
            return .pickerView
        case .surfaceArea, .yearOfConstruction, .numberOfLots, .heightUnderCeiling, .caveSurface:
            return .textField
        case .easyPark, .internet, .syndicate, .light, .dualAspect, .vmc, .humidity, .heatingType, .electricity, .electricityMeters, .toilet, .bathroom, .doubleGlazing, .reconfiguration, .cave, .parking:
            return .segment
        }
    }
}

typealias ChecklistSection = [[ChecklistItem]]

enum ChecklistSections {
    case general
    case district
    case apartmentBlock
    case apartment
    
    var title: String {
        switch self {
        case .general:
            return "Général"
        case .district:
            return "Quartier"
        case .apartmentBlock:
            return "Immeuble"
        case .apartment:
            return "Appartement"
        }
    }
    
    var number: Int {
        switch self {
        case .general:
            return 0
        case .district:
            return 1
        case .apartmentBlock:
            return 2
        case .apartment:
            return 3
        }
    }
}

