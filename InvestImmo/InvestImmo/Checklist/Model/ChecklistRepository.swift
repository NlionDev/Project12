//
//  ChecklistData.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 04/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ChecklistRepository {
    
    //MARK: Properties
    let realm = AppDelegate.realm
    private var checklistGeneral = ChecklistGeneral()
    private var checklistDistrict = ChecklistDistrict()
    private var checklistApartmentBlock = ChecklistApartmentBlock()
    private var checklistApartment = ChecklistApartment()
    lazy var myChecklistGeneral: Results<ChecklistGeneral> = {
        realm?.objects(ChecklistGeneral.self)}()!
    lazy var myChecklistDistrict: Results<ChecklistDistrict> = {
        realm?.objects(ChecklistDistrict.self)}()!
    lazy var myChecklistApartmentBlock: Results<ChecklistApartmentBlock> = {
        realm?.objects(ChecklistApartmentBlock.self)}()!
    lazy var myChecklistApartment: Results<ChecklistApartment> = {
        realm?.objects(ChecklistApartment.self)}()!
    
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
    let allTitles = [
        ["Date de la visite", "Type de bien", "Superficie"],
        ["Nuisances", "Atouts", "Transports en commun", "Stationnement facile"],
        ["Année de construction", "Nombre de lots", "Internet", "Syndicat", "Qualité façades", "Qualité toitures", "Qualité communs"],
        ["Diagnostic de performances énergétiques", "Lumineux", "Traversant", "VMC", "Présence d'humidité", "Hauteur sous plafond", "Planéité des sols", "Isolation", "Insonorisation", "Orientation", "Vue de la chambre", "Vue de la pièce de vie", "Energie du chauffage", "Type de chauffage", "Electricité au normes", "Compteur individuel", "WC isolé", "Salle de bain moderne", "Etat robinetterie", "Etat des sols", "Etat des murs", "Etat des volets", "Double vitrage", "Reconfiguration possible", "Présence de cave", "Surface cave", "Parking", "Elements différenciants par rapport aux autres biens"]
    ]
    var pickerCells = [ChecklistPickerTableViewCell]()
    var textFieldCells = [ChecklistTextFieldTableViewCell]()
    var textViewCells = [TextViewTableViewCell]()
    let estateTypeForPicker = ["Studio", "T2", "T3", "T4", "T5", "Maison de village", "Villa", "Immeuble"]
    let qualityForPicker = ["Trés mauvais", "Mauvais", "Bon", "Trés bon", "Non concerné"]
    let dpeForPicker = ["A", "B", "C", "D", "E", "F", "G"]
    let directionForPicker = ["Sud-Est", "Sud", "Sud-Ouest", "Ouest", "Nord-Ouest", "Nord", "Nord-Est", "Est"]
    let roomViewForPicker = ["Rue", "Cour", "Non concerné"]
    let heatingSystemForPicker = ["Electrique", "A gaz", "Au fioul", "A bois", "Solaire"]
    
    //MARK: - Public Methods
    func saveNewChecklistGeneral(name: String, project: Project, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
        project.name = name
        checklistGeneral.name = name
        checklistGeneral.estateType = checklistRepo.checklistData[0]["Type de bien"]
        checklistGeneral.visitDate = checklistRepo.checklistData[0]["Date de la visite"]
        checklistGeneral.surfaceArea = checklistRepo.checklistData[0]["Superficie"]
        realm.safeWrite {
            realm.add(checklistGeneral)
            realm.add(project)
        }
    }
    
    func saveChecklistGeneralToExistantProject(project: Project, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
        checklistGeneral.name = project.name
        checklistGeneral.estateType = checklistRepo.checklistData[0]["Type de bien"]
        checklistGeneral.visitDate = checklistRepo.checklistData[0]["Date de la visite"]
        checklistGeneral.surfaceArea = checklistRepo.checklistData[0]["Superficie"]
        realm.safeWrite {
            realm.add(checklistGeneral)
        }
    }
    
    func saveChecklistDistrict(name: String, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
        checklistDistrict.name = name
        checklistDistrict.problem = checklistRepo.checklistData[1]["Nuisances"]
        checklistDistrict.advantage = checklistRepo.checklistData[1]["Atouts"]
        checklistDistrict.transports = checklistRepo.checklistData[1]["Transports en commun"]
        checklistDistrict.easyPark = checklistRepo.checklistData[1]["Stationnement facile"]
        realm.safeWrite {
            realm.add(checklistDistrict)
        }
    }
    
    func saveChecklistApartmentBlock(name: String, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
        checklistApartmentBlock.name = name
        checklistApartmentBlock.yearOfConstruction = checklistRepo.checklistData[2]["Année de construction"]
        checklistApartmentBlock.numberOfLots = checklistRepo.checklistData[2]["Nombre de lots"]
        checklistApartmentBlock.internet = checklistRepo.checklistData[2]["Internet"]
        checklistApartmentBlock.syndicate = checklistRepo.checklistData[2]["Syndicat"]
        checklistApartmentBlock.facade = checklistRepo.checklistData[2]["Qualité façades"]
        checklistApartmentBlock.roof = checklistRepo.checklistData[2]["Qualité toitures"]
        checklistApartmentBlock.communalAreas = checklistRepo.checklistData[2]["Qualité communs"]
        realm.safeWrite {
            realm.add(checklistApartmentBlock)
        }
    }
    
    func saveChecklistApartment(name: String, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
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
        realm.safeWrite {
            realm.add(checklistApartment)
        }
    }
    
    func getChecklistGeneralWithProjectName(name: String) -> ChecklistGeneral {
        var checklistToReturn = ChecklistGeneral()
        for checklist in myChecklistGeneral {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    func getChecklistDistrictWithProjectName(name: String) -> ChecklistDistrict {
        var checklistToReturn = ChecklistDistrict()
        for checklist in myChecklistDistrict {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    func getChecklistApartmentBlocklWithProjectName(name: String) -> ChecklistApartmentBlock {
        var checklistToReturn = ChecklistApartmentBlock()
        for checklist in myChecklistApartmentBlock {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    func getChecklistApartmentWithProjectName(name: String) -> ChecklistApartment {
        var checklistToReturn = ChecklistApartment()
        for checklist in myChecklistApartment {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }

    func getSavedChecklistData(general: ChecklistGeneral, district: ChecklistDistrict, block: ChecklistApartmentBlock, apartment: ChecklistApartment) -> [[String]] {
        var results = [[String]]()
        results.append(getSavedChecklistGeneralData(checklist: general))
        results.append(getSavedChecklistDistrictData(checklist: district))
        results.append(getSavedChecklistApartmentBlockData(checklist: block))
        results.append(getSavedChecklistApartmentData(checklist: apartment))
        return results
    }
    
    func deleteChecklist(checklistGeneralToDelete: Results<ChecklistGeneral>, checklistDistrictToDelete: Results<ChecklistDistrict>, checklistApartmentBlockToDelete: Results<ChecklistApartmentBlock>, checklistApartmentToDelete: Results<ChecklistApartment>) {
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.delete(checklistGeneralToDelete)
            realm.delete(checklistDistrictToDelete)
            realm.delete(checklistApartmentBlockToDelete)
            realm.delete(checklistApartmentToDelete)
        }
    }
    
    //MARK: - Private Methods
    private func getSavedChecklistGeneralData(checklist: ChecklistGeneral) -> [String] {
        var results = [String]()
        if let visitDate = checklist.visitDate,
            let estateType = checklist.estateType,
            let surfaceArea = checklist.surfaceArea {
            results.append(visitDate)
            results.append(estateType)
            results.append(surfaceArea)
        }
        return results
    }
    
    private func getSavedChecklistDistrictData(checklist: ChecklistDistrict) -> [String] {
        var results = [String]()
        if let problem = checklist.problem,
            let advantage = checklist.advantage,
            let transports = checklist.transports,
            let easyPark = checklist.easyPark {
            results.append(problem)
            results.append(advantage)
            results.append(transports)
            results.append(easyPark)
        }
        return results
    }
    
    private func getSavedChecklistApartmentBlockData(checklist: ChecklistApartmentBlock) -> [String] {
        var results = [String]()
        if let construction = checklist.yearOfConstruction,
            let lots = checklist.numberOfLots,
            let internet = checklist.internet,
            let syndicate = checklist.syndicate,
            let facade = checklist.facade,
            let roof = checklist.roof,
            let communalAreas = checklist.communalAreas {
            results.append(construction)
            results.append(lots)
            results.append(internet)
            results.append(syndicate)
            results.append(facade)
            results.append(roof)
            results.append(communalAreas)
        }
        return results
    }
    
    private func getSavedChecklistApartmentData(checklist: ChecklistApartment) -> [String] {
        var results = [String]()
        if let dpe = checklist.dpe,
            let light = checklist.light,
            let dualAspect = checklist.dualAspect,
            let vmc = checklist.vmc,
            let humidity = checklist.humidity,
            let height = checklist.heightUnderCeiling,
            let planeness = checklist.planeness,
            let insulation = checklist.insulation,
            let sound = checklist.soundInsulation,
            let direction = checklist.direction,
            let bedroom = checklist.bedroomView,
            let lifeview = checklist.liferoomView,
            let heatingSystem = checklist.heatingSystem,
            let heatingType = checklist.heatingType,
            let electricity = checklist.electricity,
            let electricityMeters = checklist.electricityMeters,
            let toilet = checklist.toilet,
            let bathroom = checklist.bathroom,
            let plumbing = checklist.plumbingQuality,
            let ground = checklist.groundQuality,
            let wall = checklist.wallQuality,
            let shutters = checklist.shuttersQuality,
            let glazing = checklist.doubleGlazing,
            let reconfiguration = checklist.reconfiguration,
            let cave = checklist.cave,
            let caveSurface = checklist.caveSurface,
            let parking = checklist.parking,
            let elements = checklist.distinguishElements {
            results.append(dpe)
            results.append(light)
            results.append(dualAspect)
            results.append(vmc)
            results.append(humidity)
            results.append(height)
            results.append(planeness)
            results.append(insulation)
            results.append(sound)
            results.append(direction)
            results.append(bedroom)
            results.append(lifeview)
            results.append(heatingSystem)
            results.append(heatingType)
            results.append(electricity)
            results.append(electricityMeters)
            results.append(toilet)
            results.append(bathroom)
            results.append(plumbing)
            results.append(ground)
            results.append(wall)
            results.append(shutters)
            results.append(glazing)
            results.append(reconfiguration)
            results.append(cave)
            results.append(caveSurface)
            results.append(parking)
            results.append(elements)
        }
        return results
    }
    
}
