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

/// Class for ChecklistRepository
class ChecklistRepository {
    
    //MARK: Properties
    
    /// Instance of Realm
    let realm = AppDelegate.realm
    
    /// Instance of ChecklistGeneral
    private var checklistGeneral = ChecklistGeneral()
    
    /// Instance of ChecklistDistrict
    private var checklistDistrict = ChecklistDistrict()
    
    /// Instance of ChecklistApartmentBlock
    private var checklistApartmentBlock = ChecklistApartmentBlock()
    
    /// Instance of ChecklistApartment
    private var checklistApartment = ChecklistApartment()
    
    /// Property to store saved ChecklistGeneral
    lazy var myChecklistGeneral: Results<ChecklistGeneral> = {
        realm?.objects(ChecklistGeneral.self)}()!
    
    /// Property to store saved ChecklistDistrict
    lazy var myChecklistDistrict: Results<ChecklistDistrict> = {
        realm?.objects(ChecklistDistrict.self)}()!
    
    /// Property to store saved ChecklistApartmentBlock
    lazy var myChecklistApartmentBlock: Results<ChecklistApartmentBlock> = {
        realm?.objects(ChecklistApartmentBlock.self)}()!
    
    /// Property to store saved ChecklistApartment
    lazy var myChecklistApartment: Results<ChecklistApartment> = {
        realm?.objects(ChecklistApartment.self)}()!
    
    /// Dictionary for Checklist Items
    let sections: ChecklistSection = [
        [ChecklistItem.visitDate, ChecklistItem.estateType, ChecklistItem.surfaceArea],
        [ChecklistItem.problem, ChecklistItem.advantage, ChecklistItem.transports, ChecklistItem.easyPark],
        [ChecklistItem.yearOfConstruction, ChecklistItem.numberOfLots, ChecklistItem.internet, ChecklistItem.syndicate, ChecklistItem.facade, ChecklistItem.roof, ChecklistItem.communalAreas],
        [ChecklistItem.dpe, ChecklistItem.light, ChecklistItem.dualAspect, ChecklistItem.vmc, ChecklistItem.humidity, ChecklistItem.heightUnderCeiling, ChecklistItem.planeness, ChecklistItem.insulation, ChecklistItem.soundInsulation, ChecklistItem.direction, ChecklistItem.bedroomView, ChecklistItem.lifeRoomView, ChecklistItem.heatingSystem, ChecklistItem.heatingType, ChecklistItem.electricity, ChecklistItem.electricityMeters, ChecklistItem.toilet, ChecklistItem.bathroom, ChecklistItem.plumbingQuality, ChecklistItem.groundQuality, ChecklistItem.wallQuality, ChecklistItem.shutters, ChecklistItem.doubleGlazing, ChecklistItem.reconfiguration, ChecklistItem.cave, ChecklistItem.caveSurface, ChecklistItem.parking, ChecklistItem.distinguishElements]
    ]
    
    /// Dictionary for store checklist data
    var checklistData = [
        [ChecklistItem.visitDate.titles: emptyString, ChecklistItem.estateType.titles: emptyString, ChecklistItem.surfaceArea.titles: emptyString],
        [ChecklistItem.problem.titles: emptyString, ChecklistItem.advantage.titles: emptyString, ChecklistItem.transports.titles: emptyString, ChecklistItem.easyPark.titles: emptyString],
        [ChecklistItem.yearOfConstruction.titles: emptyString, ChecklistItem.numberOfLots.titles: emptyString, ChecklistItem.internet.titles: emptyString, ChecklistItem.syndicate.titles: emptyString, ChecklistItem.facade.titles: emptyString, ChecklistItem.roof.titles: emptyString, ChecklistItem.communalAreas.titles: emptyString],
        [ChecklistItem.dpe.titles: emptyString, ChecklistItem.light.titles: emptyString, ChecklistItem.dualAspect.titles: emptyString, ChecklistItem.vmc.titles: emptyString, ChecklistItem.humidity.titles: emptyString, ChecklistItem.heightUnderCeiling.titles: emptyString, ChecklistItem.planeness.titles: emptyString, ChecklistItem.insulation.titles: emptyString, ChecklistItem.soundInsulation.titles: emptyString, ChecklistItem.direction.titles: emptyString, ChecklistItem.bedroomView.titles: emptyString, ChecklistItem.lifeRoomView.titles: emptyString, ChecklistItem.heatingSystem.titles: emptyString, ChecklistItem.heatingType.titles: emptyString, ChecklistItem.electricity.titles: emptyString, ChecklistItem.electricityMeters.titles: emptyString, ChecklistItem.toilet.titles: emptyString, ChecklistItem.bathroom.titles: emptyString, ChecklistItem.plumbingQuality.titles: emptyString, ChecklistItem.groundQuality.titles: emptyString, ChecklistItem.wallQuality.titles: emptyString, ChecklistItem.shutters.titles: emptyString, ChecklistItem.doubleGlazing.titles: emptyString, ChecklistItem.reconfiguration.titles: emptyString, ChecklistItem.cave.titles: emptyString, ChecklistItem.caveSurface.titles: emptyString, ChecklistItem.parking.titles: emptyString, ChecklistItem.distinguishElements.titles: emptyString]
    ]
    
    /// Dictionary for store all checklist items titles
    let allTitles = [
        [ChecklistItem.visitDate.titles, ChecklistItem.estateType.titles, ChecklistItem.surfaceArea.titles],
            [ChecklistItem.problem.titles, ChecklistItem.advantage.titles, ChecklistItem.transports.titles, ChecklistItem.easyPark.titles],
            [ChecklistItem.yearOfConstruction.titles, ChecklistItem.numberOfLots.titles, ChecklistItem.internet.titles, ChecklistItem.syndicate.titles, ChecklistItem.facade.titles, ChecklistItem.roof.titles, ChecklistItem.communalAreas.titles],
            [ChecklistItem.dpe.titles, ChecklistItem.light.titles, ChecklistItem.dualAspect.titles, ChecklistItem.vmc.titles, ChecklistItem.humidity.titles, ChecklistItem.heightUnderCeiling.titles, ChecklistItem.planeness.titles, ChecklistItem.insulation.titles, ChecklistItem.soundInsulation.titles, ChecklistItem.direction.titles, ChecklistItem.bedroomView.titles, ChecklistItem.lifeRoomView.titles, ChecklistItem.heatingSystem.titles, ChecklistItem.heatingType.titles, ChecklistItem.electricity.titles, ChecklistItem.electricityMeters.titles, ChecklistItem.toilet.titles, ChecklistItem.bathroom.titles, ChecklistItem.plumbingQuality.titles, ChecklistItem.groundQuality.titles, ChecklistItem.wallQuality.titles, ChecklistItem.shutters.titles, ChecklistItem.doubleGlazing.titles, ChecklistItem.reconfiguration.titles, ChecklistItem.cave.titles, ChecklistItem.caveSurface.titles, ChecklistItem.parking.titles, ChecklistItem.distinguishElements.titles]
        ]
    
    /// Array for store checklist pickercells
    var pickerCells = [ChecklistPickerTableViewCell]()
    
    /// Array for store checklist textfield cells
    var textFieldCells = [ChecklistTextFieldTableViewCell]()
    
    /// Array for store checklist textview cells
    var textViewCells = [TextViewTableViewCell]()
    
    /// Array for store data to present in estate type pickerview
    let estateTypeForPicker = ["Studio", "T2", "T3", "T4", "T5", "Maison de village", "Villa", "Immeuble"]
    
    /// Array for store data to present in quality pickerview
    let qualityForPicker = ["Trés mauvais", "Mauvais", "Bon", "Trés bon", "Non concerné"]
    
    /// Array for store data to present in dpe pickerview
    let dpeForPicker = ["A", "B", "C", "D", "E", "F", "G"]
    
    /// Array for store data to present in direction pickerview
    let directionForPicker = ["Sud-Est", "Sud", "Sud-Ouest", "Ouest", "Nord-Ouest", "Nord", "Nord-Est", "Est"]
    
    /// Array for store data to present in roomview pickerview
    let roomViewForPicker = ["Rue", "Cour", "Non concerné"]
    
    /// Array for store data to present in heatingsystem pickerview
    let heatingSystemForPicker = ["Electrique", "A gaz", "Au fioul", "A bois", "Solaire"]
    
    //MARK: - Public Methods
    
    /// Method for save checklist general data in a new project
    func saveNewChecklistGeneral(name: String, project: Project, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
        project.name = name
        checklistGeneral.name = name
        checklistGeneral.estateType = checklistRepo.checklistData[ChecklistSections.general.number][ChecklistItem.estateType.titles]
        checklistGeneral.visitDate = checklistRepo.checklistData[ChecklistSections.general.number][ChecklistItem.visitDate.titles]
        checklistGeneral.surfaceArea = checklistRepo.checklistData[ChecklistSections.general.number][ChecklistItem.surfaceArea.titles]
        realm.safeWrite {
            realm.add(checklistGeneral)
            realm.add(project)
        }
    }
    
    /// Method for save checklist general data in an existant project
    func saveChecklistGeneralToExistantProject(project: Project, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
        checklistGeneral.name = project.name
        checklistGeneral.estateType = checklistRepo.checklistData[ChecklistSections.general.number][ChecklistItem.estateType.titles]
        checklistGeneral.visitDate = checklistRepo.checklistData[ChecklistSections.general.number][ChecklistItem.visitDate.titles]
        checklistGeneral.surfaceArea = checklistRepo.checklistData[ChecklistSections.general.number][ChecklistItem.surfaceArea.titles]
        realm.safeWrite {
            realm.add(checklistGeneral)
        }
    }
    
    /// Method for save checklist district data
    func saveChecklistDistrict(name: String, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
        checklistDistrict.name = name
        checklistDistrict.problem = checklistRepo.checklistData[ChecklistSections.district.number][ChecklistItem.problem.titles]
        checklistDistrict.advantage = checklistRepo.checklistData[ChecklistSections.district.number][ChecklistItem.advantage.titles]
        checklistDistrict.transports = checklistRepo.checklistData[ChecklistSections.district.number][ChecklistItem.transports.titles]
        checklistDistrict.easyPark = checklistRepo.checklistData[ChecklistSections.district.number][ChecklistItem.easyPark.titles]
        realm.safeWrite {
            realm.add(checklistDistrict)
        }
    }
    
    /// Method for save checklist apartment block data
    func saveChecklistApartmentBlock(name: String, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
        checklistApartmentBlock.name = name
        checklistApartmentBlock.yearOfConstruction = checklistRepo.checklistData[ChecklistSections.apartmentBlock.number][ChecklistItem.yearOfConstruction.titles]
        checklistApartmentBlock.numberOfLots = checklistRepo.checklistData[ChecklistSections.apartmentBlock.number][ChecklistItem.numberOfLots.titles]
        checklistApartmentBlock.internet = checklistRepo.checklistData[ChecklistSections.apartmentBlock.number][ChecklistItem.internet.titles]
        checklistApartmentBlock.syndicate = checklistRepo.checklistData[ChecklistSections.apartmentBlock.number][ChecklistItem.syndicate.titles]
        checklistApartmentBlock.facade = checklistRepo.checklistData[ChecklistSections.apartmentBlock.number][ChecklistItem.facade.titles]
        checklistApartmentBlock.roof = checklistRepo.checklistData[ChecklistSections.apartmentBlock.number][ChecklistItem.roof.titles]
        checklistApartmentBlock.communalAreas = checklistRepo.checklistData[ChecklistSections.apartmentBlock.number][ChecklistItem.communalAreas.titles]
        realm.safeWrite {
            realm.add(checklistApartmentBlock)
        }
    }
    
    /// Method for save checklist apartment data
    func saveChecklistApartment(name: String, checklistRepo: ChecklistRepository) {
        guard let realm = realm else {return}
        checklistApartment.name = name
        checklistApartment.dpe = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.dpe.titles]
        checklistApartment.light = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.light.titles]
        checklistApartment.dualAspect = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.dualAspect.titles]
        checklistApartment.vmc = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.vmc.titles]
        checklistApartment.humidity = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.humidity.titles]
        checklistApartment.heightUnderCeiling = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.heightUnderCeiling.titles]
        checklistApartment.planeness = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.planeness.titles]
        checklistApartment.insulation = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.insulation.titles]
        checklistApartment.soundInsulation = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.soundInsulation.titles]
        checklistApartment.direction = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.direction.titles]
        checklistApartment.bedroomView = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.bedroomView.titles]
        checklistApartment.liferoomView = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.lifeRoomView.titles]
        checklistApartment.heatingSystem = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.heatingSystem.titles]
        checklistApartment.heatingType = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.heatingType.titles]
        checklistApartment.electricity = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.electricity.titles]
        checklistApartment.electricityMeters = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.electricityMeters.titles]
        checklistApartment.toilet = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.toilet.titles]
        checklistApartment.bathroom = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.bathroom.titles]
        checklistApartment.plumbingQuality = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.plumbingQuality.titles]
        checklistApartment.groundQuality = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.groundQuality.titles]
        checklistApartment.wallQuality = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.wallQuality.titles]
        checklistApartment.shuttersQuality = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.shutters.titles]
        checklistApartment.doubleGlazing = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.doubleGlazing.titles]
        checklistApartment.reconfiguration = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.reconfiguration.titles]
        checklistApartment.cave = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.cave.titles]
        checklistApartment.caveSurface = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.caveSurface.titles]
        checklistApartment.parking = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.parking.titles]
        checklistApartment.distinguishElements = checklistRepo.checklistData[ChecklistSections.apartment.number][ChecklistItem.distinguishElements.titles]
        realm.safeWrite {
            realm.add(checklistApartment)
        }
    }
    
    /// Method for retrieve checklist general with project name
    func getChecklistGeneralWithProjectName(name: String) -> ChecklistGeneral {
        var checklistToReturn = ChecklistGeneral()
        for checklist in myChecklistGeneral {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    /// Method for retrieve checklist district with project name
    func getChecklistDistrictWithProjectName(name: String) -> ChecklistDistrict {
        var checklistToReturn = ChecklistDistrict()
        for checklist in myChecklistDistrict {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    /// Method for retrieve checklist apartment block with project name
    func getChecklistApartmentBlocklWithProjectName(name: String) -> ChecklistApartmentBlock {
        var checklistToReturn = ChecklistApartmentBlock()
        for checklist in myChecklistApartmentBlock {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    /// Method for retrieve checklist apartment with project name
    func getChecklistApartmentWithProjectName(name: String) -> ChecklistApartment {
        var checklistToReturn = ChecklistApartment()
        for checklist in myChecklistApartment {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }

    /// Method for retrieve data from specific checklist
    func getSavedChecklistData(general: ChecklistGeneral, district: ChecklistDistrict, block: ChecklistApartmentBlock, apartment: ChecklistApartment) -> [[String]] {
        var results = [[String]]()
        results.append(getSavedChecklistGeneralData(checklist: general))
        results.append(getSavedChecklistDistrictData(checklist: district))
        results.append(getSavedChecklistApartmentBlockData(checklist: block))
        results.append(getSavedChecklistApartmentData(checklist: apartment))
        return results
    }
    
    /// Method for delete specific checklist
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
    
    /// Method for retrieve data of specific checklist general
    private func getSavedChecklistGeneralData(checklist: ChecklistGeneral) -> [String] {
        var results = [String]()
        if let visitDate = checklist.visitDate,
            let estateType = checklist.estateType,
            let surfaceArea = checklist.surfaceArea {
            results.append(visitDate)
            results.append(estateType)
            results.append(surfaceArea + ChecklistItem.surfaceArea.unit)
        }
        return results
    }
    
    /// Method for retrieve data of specific checklist district
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
    
    /// Method for retrieve data of specific checklist apartment block
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
    
    /// Method for retrieve data of specific checklist apartment
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
            results.append(height + ChecklistItem.heightUnderCeiling.unit)
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
            results.append(caveSurface + ChecklistItem.caveSurface.unit)
            results.append(parking)
            results.append(elements)
        }
        return results
    }
    
}
