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
    
    
    //MARK: - Methods
    
    func saveNewChecklistGeneral(name: String, project: Project, checklistGeneral: ChecklistGeneral, realmRepo: RealmRepository, checklistRepo: ChecklistRepository) {
        project.name = name
        checklistGeneral.name = name
        checklistGeneral.estateType = checklistRepo.checklistData[0]["Type de bien"]
        checklistGeneral.visitDate = checklistRepo.checklistData[0]["Date de la visite"]
        checklistGeneral.surfaceArea = checklistRepo.checklistData[0]["Superficie"]
        try! realmRepo.realm.write {
            realmRepo.realm.add(checklistGeneral)
            realmRepo.realm.add(project)
        }
    }
    
    func addChecklistGeneralToExistantProject(project: Project, checklistGeneral: ChecklistGeneral, realmRepo: RealmRepository, checklistRepo: ChecklistRepository) {
        checklistGeneral.name = project.name
        checklistGeneral.estateType = checklistRepo.checklistData[0]["Type de bien"]
        checklistGeneral.visitDate = checklistRepo.checklistData[0]["Date de la visite"]
        checklistGeneral.surfaceArea = checklistRepo.checklistData[0]["Superficie"]
        try! realmRepo.realm.write {
            realmRepo.realm.add(checklistGeneral)
        }
    }
    
    func saveChecklistDistrict(name: String, checklistDistrict: ChecklistDistrict, realmRepo: RealmRepository, checklistRepo: ChecklistRepository) {
        checklistDistrict.name = name
        checklistDistrict.problem = checklistRepo.checklistData[1]["Nuisances"]
        checklistDistrict.advantage = checklistRepo.checklistData[1]["Atouts"]
        checklistDistrict.transports = checklistRepo.checklistData[1]["Transports en commun"]
        checklistDistrict.easyPark = checklistRepo.checklistData[1]["Stationnement facile"]
        try! realmRepo.realm.write {
            realmRepo.realm.add(checklistDistrict)
        }
    }
    
    func saveChecklistApartmentBlock(name: String, checklistApartmentBlock: ChecklistApartmentBlock, realmRepo: RealmRepository, checklistRepo: ChecklistRepository) {
        checklistApartmentBlock.name = name
        checklistApartmentBlock.yearOfConstruction = checklistRepo.checklistData[2]["Année de construction"]
        checklistApartmentBlock.numberOfLots = checklistRepo.checklistData[2]["Nombre de lots"]
        checklistApartmentBlock.internet = checklistRepo.checklistData[2]["Internet"]
        checklistApartmentBlock.syndicate = checklistRepo.checklistData[2]["Syndicat"]
        checklistApartmentBlock.facade = checklistRepo.checklistData[2]["Qualité façades"]
        checklistApartmentBlock.roof = checklistRepo.checklistData[2]["Qualité toitures"]
        checklistApartmentBlock.communalAreas = checklistRepo.checklistData[2]["Qualité communs"]
        try! realmRepo.realm.write {
            realmRepo.realm.add(checklistApartmentBlock)
        }
    }
    
    func saveChecklistApartment(name: String, checklistApartment: ChecklistApartment, realmRepo: RealmRepository, checklistRepo: ChecklistRepository) {
        checklistApartment.name = name
        checklistApartment.dpe = checklistRepo.checklistData[3]["Diagnostic de performances énergétiques"]
        checklistApartment.light = checklistRepo.checklistData[3]["Lumineux"]
        checklistApartment.dualAspect = checklistRepo.checklistData[3]["Traversant"]
        checklistApartment.vmc = checklistRepo.checklistData[3]["VMC"]
        checklistApartment.humidity = checklistRepo.checklistData[3]["Présence d'humidité"]
        checklistApartment.heightUnderCeiling = checklistRepo.checklistData[3]["Hauteur sous plafond"]
        checklistApartment.planeness = checklistRepo.checklistData[3]["Planéité des sols"]
        checklistApartment.insulation = checklistRepo.checklistData[3]["Isolation"]
        checklistApartment.soundInsulation = checklistRepo.checklistData[3]["Insonorisation"]
        checklistApartment.direction = checklistRepo.checklistData[3]["Orientation"]
        checklistApartment.bedroomView = checklistRepo.checklistData[3]["Vue de la chambre"]
        checklistApartment.liferoomView = checklistRepo.checklistData[3]["Vue de la pièce de vie"]
        checklistApartment.heatingSystem = checklistRepo.checklistData[3]["Energie du chauffage"]
        checklistApartment.heatingType = checklistRepo.checklistData[3]["Type de chauffage"]
        checklistApartment.electricity = checklistRepo.checklistData[3]["Electricité au normes"]
        checklistApartment.electricityMeters = checklistRepo.checklistData[3]["Compteur individuel"]
        checklistApartment.toilet = checklistRepo.checklistData[3]["WC isolé"]
        checklistApartment.bathroom = checklistRepo.checklistData[3]["Salle de bain moderne"]
        checklistApartment.plumbingQuality = checklistRepo.checklistData[3]["Etat robinetterie"]
        checklistApartment.groundQuality = checklistRepo.checklistData[3]["Etat des sols"]
        checklistApartment.wallQuality = checklistRepo.checklistData[3]["Etat des murs"]
        checklistApartment.shuttersQuality = checklistRepo.checklistData[3]["Etat des volets"]
        checklistApartment.doubleGlazing = checklistRepo.checklistData[3]["Double vitrage"]
        checklistApartment.reconfiguration = checklistRepo.checklistData[3]["Reconfiguration possible"]
        checklistApartment.cave = checklistRepo.checklistData[3]["Présence de cave"]
        checklistApartment.caveSurface = checklistRepo.checklistData[3]["Surface cave"]
        checklistApartment.parking = checklistRepo.checklistData[3]["Parking"]
        checklistApartment.distinguishElements = checklistRepo.checklistData[3]["Elements différenciants par rapport aux autres biens"]
        try! realmRepo.realm.write {
            realmRepo.realm.add(checklistApartment)
        }
    }
    
}
