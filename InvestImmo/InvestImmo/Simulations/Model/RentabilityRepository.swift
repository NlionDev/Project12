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
    let allTitles = ["Prix du bien", "Coût des travaux", "Frais de notaire", "Loyer mensuel", "Taxe foncière", "Frais d'entretien", "Charges de copropriété", "Frais de gérance", "Assurance loyers impayés", "Coût du crédit", "Rendement Brut", "Rendement Net", "Cash-Flow Annuel", "Cash-Flow Mensuel"]
    let resultTitles = ["Rendement Brut", "Rendement Net", "Cash-Flow Annuel", "Cash-Flow Mensuel"]
    let cells: RentabilityCells = [RentabilityItem.estatePrice, RentabilityItem.worksCost, RentabilityItem.notaryFees, RentabilityItem.monthlyRent, RentabilityItem.propertyTax, RentabilityItem.maintenanceFees, RentabilityItem.charges, RentabilityItem.managementFees, RentabilityItem.insurance, RentabilityItem.creditCost]
    var rentaTextFieldWithoutSubtitleCells = [TextFieldWithoutSubtitleTableViewCell]()
    var rentaTextFieldWithSubtitleCells = [TextFieldWithSubtitleTableViewCell]()
    var results = [String]()
    var resultsForPositiveCheck = [String]()
    var rentabilityData = ["Prix du bien": "", "Coût des travaux": "", "Frais de notaire": "", "Loyer mensuel": "", "Taxe foncière": "", "Frais d'entretien": "", "Charges de copropriété": "", "Frais de gérance": "", "Assurance loyers impayés": "", "Coût du crédit": ""]
    var rentabilityResultData = ["Rendement Brut": "", "Rendement Net": "", "Cash-Flow Annuel": "", "Cash-Flow Mensuel": ""]
    
    //MARK: - Methods
    func saveNewRentabilitySimulation(name: String, project: Project, rentaRepo: RentabilityRepository) {
        project.name = name
        simulation.name = name
        simulation.estatePrice = rentaRepo.rentabilityData["Prix du bien"]
        simulation.worksPrice = rentaRepo.rentabilityData["Coût des travaux"]
        simulation.notaryFees = rentaRepo.rentabilityData["Frais de notaire"]
        simulation.monthlyRent = rentaRepo.rentabilityData["Loyer mensuel"]
        simulation.propertyTax = rentaRepo.rentabilityData["Taxe foncière"]
        simulation.maintenanceFees = rentaRepo.rentabilityData["Frais d'entretien"]
        simulation.charges = rentaRepo.rentabilityData["Charges de copropriété"]
        simulation.managementFees = rentaRepo.rentabilityData["Frais de gérance"]
        simulation.insurance = rentaRepo.rentabilityData["Assurance loyers impayés"]
        simulation.creditCost = rentaRepo.rentabilityData["Coût du crédit"]
        simulation.grossYield = rentaRepo.results[0]
        simulation.netYield = rentaRepo.results[1]
        simulation.annualCashflow = rentaRepo.results[2]
        simulation.mensualCashflow = rentaRepo.results[3]
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.add(project)
            realm.add(simulation)
        }
    }
    
    func addRentabilitySimulationToExistantProject(project: Project, rentaRepo: RentabilityRepository) {
        simulation.name = project.name
        simulation.estatePrice = rentaRepo.rentabilityData["Prix du bien"]
        simulation.worksPrice = rentaRepo.rentabilityData["Coût des travaux"]
        simulation.notaryFees = rentaRepo.rentabilityData["Frais de notaire"]
        simulation.monthlyRent = rentaRepo.rentabilityData["Loyer mensuel"]
        simulation.propertyTax = rentaRepo.rentabilityData["Taxe foncière"]
        simulation.maintenanceFees = rentaRepo.rentabilityData["Frais d'entretien"]
        simulation.charges = rentaRepo.rentabilityData["Charges de copropriété"]
        simulation.managementFees = rentaRepo.rentabilityData["Frais de gérance"]
        simulation.insurance = rentaRepo.rentabilityData["Assurance loyers impayés"]
        simulation.creditCost = rentaRepo.rentabilityData["Coût du crédit"]
        simulation.grossYield = rentaRepo.results[0]
        simulation.netYield = rentaRepo.results[1]
        simulation.annualCashflow = rentaRepo.results[2]
        simulation.mensualCashflow = rentaRepo.results[3]
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

}
