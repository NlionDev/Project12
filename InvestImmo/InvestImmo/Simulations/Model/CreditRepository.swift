//
//  CreditRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CreditRepository {
    
    //MARK: - Properties
    let realm = AppDelegate.realm
    private var simulation = CreditSimulation()
    lazy var mySavedCreditSimulations: Results<CreditSimulation> = {
        realm?.objects(CreditSimulation.self)}()!
    let cells: CreditCells = [CreditItem.amountToFinance, CreditItem.duration, CreditItem.rate, CreditItem.insuranceRate, CreditItem.bookingFees]
    var creditTextFieldCells = [TextFieldWithoutSubtitleTableViewCell]()
    var creditStepperCells = [StepperTableViewCell]()
    let creditDuration = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    let allTitles = [CreditItem.amountToFinance.titles, CreditItem.duration.titles, CreditItem.rate.titles, CreditItem.insuranceRate.titles, CreditItem.bookingFees.titles, CreditResultItem.mensuality.titles, CreditResultItem.interestCost.titles, CreditResultItem.insuranceCost.titles, CreditResultItem.totalCost.titles]
    let resultTitles = [CreditResultItem.mensuality.titles, CreditResultItem.interestCost.titles, CreditResultItem.insuranceCost.titles, CreditResultItem.totalCost.titles]
    var results = [String]()
    var creditData = [CreditItem.amountToFinance.titles: emptyString, CreditItem.duration.titles: emptyString, CreditItem.rate.titles: emptyString, CreditItem.insuranceRate.titles: emptyString, CreditItem.bookingFees.titles: emptyString]
    
    //MARK: - Methods
    func saveNewCreditSimulation(name: String, project: Project, creditRepo: CreditRepository) {
        guard let realm = realm else {return}
        project.name = name
        simulation.name = name
        simulation.amountToFinance = creditRepo.creditData[CreditItem.amountToFinance.titles]
        simulation.duration = creditRepo.creditData[CreditItem.duration.titles]
        simulation.rate = creditRepo.creditData[CreditItem.rate.titles]
        simulation.insuranceRate = creditRepo.creditData[CreditItem.insuranceRate.titles]
        simulation.bookingFees = creditRepo.creditData[CreditItem.bookingFees.titles]
        simulation.mensuality = creditRepo.results[CreditResultItem.mensuality.index]
        simulation.interestCost = creditRepo.results[CreditResultItem.interestCost.index]
        simulation.insuranceCost = creditRepo.results[CreditResultItem.insuranceCost.index]
        simulation.totalCost = creditRepo.results[CreditResultItem.totalCost.index]
         realm.safeWrite {
            realm.add(simulation)
            realm.add(project)
        }
    }
    
    func addCreditSimulationToExistantProject(project: Project, creditRepo: CreditRepository) {
        guard let realm = realm else {return}
        simulation.name = project.name
        simulation.amountToFinance = creditRepo.creditData[CreditItem.amountToFinance.titles]
        simulation.duration = creditRepo.creditData[CreditItem.duration.titles]
        simulation.rate = creditRepo.creditData[CreditItem.rate.titles]
        simulation.insuranceRate = creditRepo.creditData[CreditItem.insuranceRate.titles]
        simulation.bookingFees = creditRepo.creditData[CreditItem.bookingFees.titles]
        simulation.mensuality = creditRepo.results[CreditResultItem.mensuality.index]
        simulation.interestCost = creditRepo.results[CreditResultItem.interestCost.index]
        simulation.insuranceCost = creditRepo.results[CreditResultItem.insuranceCost.index]
        simulation.totalCost = creditRepo.results[CreditResultItem.totalCost.index]
        realm.safeWrite {
            realm.add(simulation)
        }
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
    
    func getSavedCreditSimulationResultsData(creditSimulation: CreditSimulation) -> [String] {
        var results = [String]()
        if let amountTofinance = creditSimulation.amountToFinance,
            let duration = creditSimulation.duration,
            let rate = creditSimulation.rate,
            let insuranceRate = creditSimulation.insuranceRate,
            let bookingFees = creditSimulation.bookingFees,
            let mensuality = creditSimulation.mensuality,
            let interestCost = creditSimulation.interestCost,
            let insuranceCost = creditSimulation.insuranceCost,
            let totalCost = creditSimulation.totalCost {
            results.append(amountTofinance + eurosUnit)
            results.append(duration + yearsUnit)
            results.append(rate + percentUnit)
            results.append(insuranceRate + percentUnit)
            results.append(bookingFees + eurosUnit)
            results.append(mensuality)
            results.append(interestCost)
            results.append(insuranceCost)
            results.append(totalCost)
        }
        return results
    }
    
    func deleteCreditSimulation(creditToDelete: Results<CreditSimulation>) {
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.delete(creditToDelete)
        }
    }

}
