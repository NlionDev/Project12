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
    
 
    let realm = try! Realm()
    lazy var myProjects: Results<Project> = {
        self.realm.objects(Project.self)}()
    lazy var mySavedRentabilitySimulations: Results<RentabilitySimulation> = {
        self.realm.objects(RentabilitySimulation.self)}()
    lazy var mySavedCreditSimulations: Results<CreditSimulation> = {
        self.realm.objects(CreditSimulation.self)}()
    lazy var checklistGeneral: Results<ChecklistGeneral> = {
        self.realm.objects(ChecklistGeneral.self)}()
    let errorAlert = ErrorAlert()
    
    //MARK: - Methods
    
    func getChecklistGeneralWithProjectName(name: String) -> ChecklistGeneral {
        var checklistToReturn = ChecklistGeneral()
        for checklist in checklistGeneral {
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
    
}
