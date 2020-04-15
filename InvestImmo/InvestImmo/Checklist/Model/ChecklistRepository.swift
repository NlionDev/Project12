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
    
    let sections: ChecklistSection = [
        [ChecklistItem.visitDate, ChecklistItem.estateType, ChecklistItem.surfaceArea],
        [ChecklistItem.problem, ChecklistItem.advantage, ChecklistItem.transports, ChecklistItem.easyPark],
        [ChecklistItem.yearOfConstruction, ChecklistItem.numberOfLots, ChecklistItem.internet, ChecklistItem.syndicate, ChecklistItem.facade, ChecklistItem.roof, ChecklistItem.communalAreas],
        [ChecklistItem.dpe, ChecklistItem.light, ChecklistItem.dualAspect, ChecklistItem.vmc, ChecklistItem.humidity, ChecklistItem.heightUnderCeiling, ChecklistItem.planeness, ChecklistItem.insulation, ChecklistItem.soundInsulation, ChecklistItem.direction, ChecklistItem.bedroomView, ChecklistItem.lifeRoomView, ChecklistItem.heatingSystem, ChecklistItem.heatingType, ChecklistItem.electricity, ChecklistItem.electricityMeters, ChecklistItem.toilet, ChecklistItem.bathroom, ChecklistItem.plumbingQuality, ChecklistItem.groundQuality, ChecklistItem.wallQuality, ChecklistItem.shutters, ChecklistItem.doubleGlazing, ChecklistItem.reconfiguration, ChecklistItem.cave, ChecklistItem.caveSurface, ChecklistItem.parking, ChecklistItem.distinguishElements]
    ]
    

    var checklistData = [
        ["Date de la visite": "", "Type de bien": "", "Superficie": ""],
        ["Nuisances": "", "Atouts": "", "Transports en commun": "", "Stationnement facile": ""],
        ["Année de construction": "", "Nombre de lots": "", "Internet": "", "Syndicat": "", "Qualité façades": "", "Qualité toitures": "", "Qualité communs": ""],
        ["Diagnostic de performances énergétiques": "", "Lumineux": "", "Traversant": "", "VMC": "", "Présence d'humidité": "", "Hauteur sous plafond": "", "Planéité des sols": "", "Isolation": "", "Insonorisation": "", "Orientation": "", "Vue de la chambre": "", "Vue de la pièce de vie": "", "Energie du chauffage": "", "Type de chauffage": "", "Electricité au normes": "", "Compteur individuel": "", "WC isolé": "", "Salle de bain moderne": "", "Etat robinetterie": "", "Etat des sols": "", "Etat des murs": "", "Etat des volets": "", "Double vitrage": "", "Reconfiguration possible": "", "Présence de cave": "", "Surface cave": "", "Parking": "", "Elements différenciants par rapport aux autres biens": ""]
    ]
    
    var pickerCells = [ChecklistPickerTableViewCell]()
    
    
    var estateTypeForPicker = ["Studio", "T2", "T3", "T4", "T5", "Maison de village", "Villa", "Immeuble"]
    var qualityForPicker = ["Trés mauvais", "Mauvais", "Bon", "Trés bon", "Non concerné"]
    var dpeForPicker = ["A", "B", "C", "D", "E", "F", "G"]
    var directionForPicker = ["Sud-Est", "Sud", "Sud-Ouest", "Ouest", "Nord-Ouest", "Nord", "Nord-Est", "Est"]
    var roomViewForPicker = ["Rue", "Cour", "Non concerné"]
    var heatingSystemForPicker = ["Electrique", "A gaz", "Au fioul", "A bois", "Solaire"]
    
}
