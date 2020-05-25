//
//  RentabilityRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RentabilityRepository {
    
    //MARK: - Properties
    let realm = AppDelegate.realm
    private var simulation = RentabilitySimulation()
    lazy var mySavedRentabilitySimulations: Results<RentabilitySimulation> = {
        self.realm?.objects(RentabilitySimulation.self)}()!
    let allTitles = [RentabilityItem.estatePrice.titles, RentabilityItem.worksCost.titles, RentabilityItem.notaryFees.titles, RentabilityItem.monthlyRent.titles, RentabilityItem.propertyTax.titles, RentabilityItem.maintenanceFees.titles, RentabilityItem.charges.titles, RentabilityItem.managementFees.titles, RentabilityItem.insurance.titles, RentabilityItem.creditCost.titles, RentabilityResultItem.grossYield.titles, RentabilityResultItem.netYield.titles, RentabilityResultItem.annualCashflow.titles, RentabilityResultItem.mensualCashflow.titles]
    let resultTitles = [RentabilityResultItem.grossYield.titles, RentabilityResultItem.netYield.titles, RentabilityResultItem.annualCashflow.titles, RentabilityResultItem.mensualCashflow.titles]
    let cells: RentabilityCells = [RentabilityItem.estatePrice, RentabilityItem.worksCost, RentabilityItem.notaryFees, RentabilityItem.monthlyRent, RentabilityItem.propertyTax, RentabilityItem.maintenanceFees, RentabilityItem.charges, RentabilityItem.managementFees, RentabilityItem.insurance, RentabilityItem.creditCost]
    var rentaTextFieldWithoutSubtitleCells = [TextFieldWithoutSubtitleTableViewCell]()
    var rentaTextFieldWithSubtitleCells = [TextFieldWithSubtitleTableViewCell]()
    var results = [String]()
    var resultsForPositiveCheck = [String]()
    var rentabilityData = [RentabilityItem.estatePrice.titles: emptyString, RentabilityItem.worksCost.titles: emptyString, RentabilityItem.notaryFees.titles: emptyString, RentabilityItem.monthlyRent.titles: emptyString, RentabilityItem.propertyTax.titles: emptyString, RentabilityItem.maintenanceFees.titles: emptyString, RentabilityItem.charges.titles: emptyString, RentabilityItem.managementFees.titles: emptyString, RentabilityItem.insurance.titles: emptyString, RentabilityItem.creditCost.titles: emptyString]
    var rentabilityResultData = [RentabilityResultItem.grossYield.titles: emptyString, RentabilityResultItem.netYield.titles: emptyString, RentabilityResultItem.annualCashflow.titles: emptyString, RentabilityResultItem.mensualCashflow.titles: emptyString]
    
    //MARK: - Methods
    func saveNewRentabilitySimulation(name: String, project: Project, rentaRepo: RentabilityRepository) {
        project.name = name
        simulation.name = name
        simulation.estatePrice = rentaRepo.rentabilityData[RentabilityItem.estatePrice.titles]
        simulation.worksPrice = rentaRepo.rentabilityData[RentabilityItem.worksCost.titles]
        simulation.notaryFees = rentaRepo.rentabilityData[RentabilityItem.notaryFees.titles]
        simulation.monthlyRent = rentaRepo.rentabilityData[RentabilityItem.monthlyRent.titles]
        simulation.propertyTax = rentaRepo.rentabilityData[RentabilityItem.propertyTax.titles]
        simulation.maintenanceFees = rentaRepo.rentabilityData[RentabilityItem.maintenanceFees.titles]
        simulation.charges = rentaRepo.rentabilityData[RentabilityItem.charges.titles]
        simulation.managementFees = rentaRepo.rentabilityData[RentabilityItem.managementFees.titles]
        simulation.insurance = rentaRepo.rentabilityData[RentabilityItem.insurance.titles]
        simulation.creditCost = rentaRepo.rentabilityData[RentabilityItem.creditCost.titles]
        simulation.grossYield = rentaRepo.results[RentabilityResultItem.grossYield.index]
        simulation.netYield = rentaRepo.results[RentabilityResultItem.netYield.index]
        simulation.annualCashflow = rentaRepo.results[RentabilityResultItem.annualCashflow.index]
        simulation.mensualCashflow = rentaRepo.results[RentabilityResultItem.mensualCashflow.index]
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.add(project)
            realm.add(simulation)
        }
    }
    
    func addRentabilitySimulationToExistantProject(project: Project, rentaRepo: RentabilityRepository) {
        simulation.name = project.name
        simulation.estatePrice = rentaRepo.rentabilityData[RentabilityItem.estatePrice.titles]
        simulation.worksPrice = rentaRepo.rentabilityData[RentabilityItem.worksCost.titles]
        simulation.notaryFees = rentaRepo.rentabilityData[RentabilityItem.notaryFees.titles]
        simulation.monthlyRent = rentaRepo.rentabilityData[RentabilityItem.monthlyRent.titles]
        simulation.propertyTax = rentaRepo.rentabilityData[RentabilityItem.propertyTax.titles]
        simulation.maintenanceFees = rentaRepo.rentabilityData[RentabilityItem.maintenanceFees.titles]
        simulation.charges = rentaRepo.rentabilityData[RentabilityItem.charges.titles]
        simulation.managementFees = rentaRepo.rentabilityData[RentabilityItem.managementFees.titles]
        simulation.insurance = rentaRepo.rentabilityData[RentabilityItem.insurance.titles]
        simulation.creditCost = rentaRepo.rentabilityData[RentabilityItem.creditCost.titles]
        simulation.grossYield = rentaRepo.results[RentabilityResultItem.grossYield.index]
        simulation.netYield = rentaRepo.results[RentabilityResultItem.netYield.index]
        simulation.annualCashflow = rentaRepo.results[RentabilityResultItem.annualCashflow.index]
        simulation.mensualCashflow = rentaRepo.results[RentabilityResultItem.mensualCashflow.index]
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.add(simulation)
        }
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
    
    func deleteRentabilitySimulation(rentabilityToDelete: Results<RentabilitySimulation>) {
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.delete(rentabilityToDelete)
        }
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
            results.append(estatePrice + eurosUnit)
            results.append(worksPrice + eurosUnit)
            results.append(notaryFees + eurosUnit)
            results.append(monthlyRent + eurosUnit)
            results.append(propertyTax + eurosUnit)
            results.append(maintenanceFees + eurosUnit)
            results.append(charges + eurosUnit)
            results.append(managementFees + percentUnit)
            results.append(insurance + eurosUnit)
            results.append(creditCost + eurosUnit)
            results.append(grossYield)
            results.append(netYield)
            results.append(annualCashflow)
            results.append(mensualCashflow)
        }
        return results
    }

}
