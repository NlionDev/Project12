//
//  RentabilityRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class RentabilityRepository {
    
    //MARK: - Properties

    let resultTitles = ["Rendement Brut", "Rendement Net", "Cash-Flow Annuel", "Cash-Flow Mensuel"]
    let cells: RentabilityCells = [RentabilityItem.estatePrice, RentabilityItem.worksCost, RentabilityItem.notaryFees, RentabilityItem.monthlyRent, RentabilityItem.propertyTax, RentabilityItem.maintenanceFees, RentabilityItem.charges, RentabilityItem.managementFees, RentabilityItem.insurance, RentabilityItem.creditCost]
    var rentaTextFieldWithoutSubtitleCells = [TextFieldWithoutSubtitleTableViewCell]()
    var rentaTextFieldWithSubtitleCells = [TextFieldWithSubtitleTableViewCell]()
    var results = [String]()
    var resultsForPositiveCheck = [String]()
    var rentabilityData = ["Prix du bien": "", "Coût des travaux": "", "Frais de notaire": "", "Loyer mensuel": "", "Taxe foncière": "", "Frais d'entretien": "", "Charges de copropriété": "", "Frais de gérance": "", "Assurance loyers impayés": "", "Coût du crédit": ""]
    var rentabilityResultData = ["Rendement Brut": "", "Rendement Net": "", "Cash-Flow Annuel": "", "Cash-Flow Mensuel": ""]
    var allTitles = ["Prix du bien", "Coût des travaux", "Frais de notaire", "Loyer mensuel", "Taxe foncière", "Frais d'entretien", "Charges de copropriété", "Frais de gérance", "Assurance loyers impayés", "Coût du crédit", "Rendement Brut", "Rendement Net", "Cash-Flow Annuel", "Cash-Flow Mensuel"]
    
    
    //MARK: - Methods
    
    func saveNewRentabilitySimulation(name: String, simulation: RentabilitySimulation, project: Project, realmRepo: RealmRepository, rentaRepo: RentabilityRepository) {
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
        try! realmRepo.realm.write {
            realmRepo.realm.add(project)
            realmRepo.realm.add(simulation)
        }
    }
    
    func addRentabilitySimulationToExistantProject(project: Project, simulation: RentabilitySimulation, realmRepo: RealmRepository, rentaRepo: RentabilityRepository) {
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
        try! realmRepo.realm.write {
            realmRepo.realm.add(simulation)
        }
    }

}
