//
//  ChecklistData.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 04/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class ChecklistRepository {
    
    
    //MARK: Properties
    
    let checklistTwoDimensionnalArray = [
        ["Date de la visite", "Type de bien", "Superficie"],
        ["Nuisances", "Atouts", "Transports en commun", "Stationnement facile"],
        ["Année de construction", "Nombre de lots", "Internet", "Syndicat", "Qualité façades", "Qualité toitures", "Qualité communs"],
        ["Diagnostic de performances énergétiques", "Lumineux", "Traversant", "VMC", "Présence d'humidité", "Hauteur sous plafond", "Planéité du sol", "Isolation", "Insonorisation", "Orientation", "Vue de la chambre", "Vue de la pièce de vie", "Energie du chauffage", "Type de chauffage", "Electricité au normes", "Compteur individuel", "WC isolé", "Salle de bain moderne", "Etat robinetterie", "Etat des sols", "Etat des murs", "Etat des volets", "Double vitrage", "Reconfiguration possible", "Présence de cave", "Surface cave", "Parking", "Elements différanciants par rapport aux autres biens"]
    ]
    
    let checklistTwoDimensionnalDictionnary = [
        ["Date de la visite": 1, "Type de bien": 2, "Superficie": 3],
        ["Nuisances": 4, "Atouts": 4, "Transports en commun": 4, "Stationnement facile": 5],
        ["Année de construction": 3, "Nombre de lots": 3, "Internet": 5, "Syndicat": 5, "Qualité façades": 2, "Qualité toitures": 2, "Qualité communs": 2],
        ["Diagnostic de performances énergétiques": 2, "Lumineux": 5, "Traversant": 5, "VMC": 5, "Présence d'humidité": 5, "Hauteur sous plafond": 3, "Planéité du sol": 2, "Isolation": 2, "Insonorisation": 2, "Orientation": 2, "Vue de la chambre": 2, "Vue de la pièce de vie": 2, "Energie du chauffage": 2, "Type de chauffage": 5, "Electricité au normes": 5, "Compteur individuel": 5, "WC isolé": 5, "Salle de bain moderne": 5, "Etat robinetterie": 2, "Etat des sols": 2, "Etat des murs": 2, "Etat des volets": 2, "Double vitrage": 5, "Reconfiguration possible": 5, "Présence de cave": 5, "Surface cave": 3, "Parking": 5, "Elements différanciants par rapport aux autres biens": 4]
    ]
    
    var checklistData = [
        ["Date de la visite": "", "Type de bien": "", "Superficie": ""],
        ["Nuisances": "", "Atouts": "", "Transports en commun": "", "Stationnement facile": ""],
        ["Année de construction": "", "Nombre de lots": "", "Internet": "", "Syndicat": "", "Qualité façades": "", "Qualité toitures": "", "Qualité communs": ""],
        ["Diagnostic de performances énergétiques": "", "Lumineux": "", "Traversant": "", "VMC": "", "Présence d'humidité": "", "Hauteur sous plafond": "", "Planéité du sol": "", "Isolation": "", "Insonorisation": "", "Orientation": "", "Vue de la chambre": "", "Vue de la pièce de vie": "", "Energie du chauffage": "", "Type de chauffage": "", "Electricité au normes": "", "Compteur individuel": "", "WC isolé": "", "Salle de bain moderne": "", "Etat robinetterie": "", "Etat des sols": "", "Etat des murs": "", "Etat des volets": "", "Double vitrage": "", "Reconfiguration possible": "", "Présence de cave": "", "Surface cave": "", "Parking": "", "Elements différanciants par rapport aux autres biens": ""]
    ]
    
    var pickerCells = [ChecklistPickerTableViewCell]()
    
    
    var estateTypeForPicker = ["Studio", "T2", "T3", "T4", "T5", "Maison de village", "Villa", "Immeuble"]
    var qualityForPicker = ["Trés mauvais", "Mauvais", "Bon", "Trés bon", "Non concerné"]
    var dpeForPicker = ["A", "B", "C", "D", "E", "F", "G"]
    var directionForPicker = ["Sud-Est", "Sud", "Sud-Ouest", "Ouest", "Nord-Ouest", "Nord", "Nord-Est", "Est"]
    var roomViewForPicker = ["Rue", "Cour", "Non concerné"]
    var heatingSystemForPicker = ["Electrique", "A gaz", "Au fioul", "A bois", "Solaire"]
    
}
