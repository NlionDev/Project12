//
//  RealmRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRepository {
    
    //MARK: - Properties
    
    private var project = Project()
    private var mapAdress = MapAdress()
    let realm = try! Realm()
    lazy var myAdresses: Results<MapAdress> = {
        self.realm.objects(MapAdress.self)}()
    lazy var myPhotos: Results<Photo> = {
        self.realm.objects(Photo.self)}()
    lazy var myProjects: Results<Project> = {
        self.realm.objects(Project.self)}()
    lazy var mySavedRentabilitySimulations: Results<RentabilitySimulation> = {
        self.realm.objects(RentabilitySimulation.self)}()
    lazy var mySavedCreditSimulations: Results<CreditSimulation> = {
        self.realm.objects(CreditSimulation.self)}()
    lazy var checklistGeneral: Results<ChecklistGeneral> = {
        self.realm.objects(ChecklistGeneral.self)}()
    lazy var checklistDistrict: Results<ChecklistDistrict> = {
        self.realm.objects(ChecklistDistrict.self)}()
    lazy var checklistApartmentBlock: Results<ChecklistApartmentBlock> = {
        self.realm.objects(ChecklistApartmentBlock.self)}()
    lazy var checklistApartment: Results<ChecklistApartment> = {
        self.realm.objects(ChecklistApartment.self)}()
    let errorAlert = ErrorAlert()
    
    //MARK: - Methods
    
    func saveEmptyNewProject(name: String) {
        project.name = name
        try! realm.write {
            realm.add(project)
        }
    }
    
    func saveMapAdressWithNewProject(project: Project, mapAdress: MapAdress) {
        try! realm.write {
            realm.add(project)
            realm.add(mapAdress)
        }
    }
    
    func saveMapAdressInExistantProject(name: String, adress: String, latitude: String, longitude: String) {
        mapAdress.name = name
        mapAdress.adress = adress
        mapAdress.latitude = latitude
        mapAdress.longitude = longitude
        try! realm.write {
            realm.add(mapAdress)
        }
    }
    
    func getMapAdressWithProjectName(name: String) -> MapAdress {
        var adressToReturn = MapAdress()
        for adress in myAdresses {
            if adress.name == name {
                adressToReturn = adress
            }
        }
        return adressToReturn
    }
    
    func getPhotosIdentifiersWithProjectName(name: String) -> [String] {
        var identifiers = [String]()
        for photo in myPhotos {
            if photo.name == name {
                if let identifier = photo.identifier {
                    identifiers.append(identifier)
                }
            }
        }
        return identifiers
    }
    
    func getChecklistGeneralWithProjectName(name: String) -> ChecklistGeneral {
        var checklistToReturn = ChecklistGeneral()
        for checklist in checklistGeneral {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    func getChecklistDistrictWithProjectName(name: String) -> ChecklistDistrict {
        var checklistToReturn = ChecklistDistrict()
        for checklist in checklistDistrict {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    func getChecklistApartmentBlocklWithProjectName(name: String) -> ChecklistApartmentBlock {
        var checklistToReturn = ChecklistApartmentBlock()
        for checklist in checklistApartmentBlock {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    func getChecklistApartmentWithProjectName(name: String) -> ChecklistApartment {
        var checklistToReturn = ChecklistApartment()
        for checklist in checklistApartment {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }

    func getRentabilitySimulationWithProjectName(name: String) -> RentabilitySimulation {
        var simulationToReturn = RentabilitySimulation()
        for simulation in mySavedRentabilitySimulations {
            if simulation.name == name {
                simulationToReturn = simulation
            }
        }
        return simulationToReturn
    }
    
    func getCreditSimulationWithProjectName(name: String) -> CreditSimulation {
        var simulationToReturn = CreditSimulation()
        for simulation in mySavedCreditSimulations {
            if simulation.name == name {
                simulationToReturn = simulation
            }
        }
        return simulationToReturn
    }
    
    func getSavedCreditSimulationResultsData(simulation: CreditSimulation) -> [String] {
        var results = [String]()
        if let amountTofinance = simulation.amountToFinance,
            let duration = simulation.duration,
            let rate = simulation.rate,
            let insuranceRate = simulation.insuranceRate,
            let bookingFees = simulation.bookingFees,
            let mensuality = simulation.mensuality,
            let interestCost = simulation.interestCost,
            let insuranceCost = simulation.insuranceCost,
            let totalCost = simulation.totalCost {
            results.append(amountTofinance + " €")
            results.append(duration + " ans")
            results.append(rate + " %")
            results.append(insuranceRate + " %")
            results.append(bookingFees + " €")
            results.append(mensuality)
            results.append(interestCost)
            results.append(insuranceCost)
            results.append(totalCost)
        }
        return results
    }
    
    func getSavedRentabilitySimulationResultsData(simulation: RentabilitySimulation) -> [String] {
        var results = [String]()
        if let estatePrice = simulation.estatePrice,
            let worksPrice = simulation.worksPrice,
            let notaryFees = simulation.notaryFees,
            let monthlyRent = simulation.monthlyRent,
            let propertyTax = simulation.propertyTax,
            let maintenanceFees = simulation.maintenanceFees,
            let charges = simulation.charges,
            let managementFees = simulation.managementFees,
            let insurance = simulation.insurance,
            let creditCost = simulation.creditCost,
            let grossYield = simulation.grossYield,
            let netYield = simulation.netYield,
            let annualCashflow = simulation.annualCashflow,
            let mensualCashflow = simulation.mensualCashflow {
            results.append(estatePrice + " €")
            results.append(worksPrice + " €")
            results.append(notaryFees + " €")
            results.append(monthlyRent + " €")
            results.append(propertyTax + " €")
            results.append(maintenanceFees + " €")
            results.append(charges + " €")
            results.append(managementFees + " %")
            results.append(insurance + " €")
            results.append(creditCost + " €")
            results.append(grossYield)
            results.append(netYield)
            results.append(annualCashflow)
            results.append(mensualCashflow)
        }
        return results
    }
    
    func getSavedChecklistData(general: ChecklistGeneral, district: ChecklistDistrict, block: ChecklistApartmentBlock, apartment: ChecklistApartment) -> [[String]] {
        var results = [[String]]()
        results.append(getSavedChecklistGeneralData(checklist: general))
        results.append(getSavedChecklistDistrictData(checklist: district))
        results.append(getSavedChecklistApartmentBlockData(checklist: block))
        results.append(getSavedChecklistApartmentData(checklist: apartment))
        return results
    }
    
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
