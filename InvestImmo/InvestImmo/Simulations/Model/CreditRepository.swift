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
    let allTitles = ["Montant à financer", "Durée", "Taux", "Taux assurance", "Frais de dossier", "Mensualités", "Coût intérêts", "Coût assurance", "Coût total"]
    let resultTitles = ["Mensualités", "Coût intérêts", "Coût assurance", "Coût total"]
    var results = [String]()
    var creditData = ["Montant à financer": "", "Durée": "", "Taux": "", "Taux assurance": "", "Frais de dossier": ""]
    
    //MARK: - Methods
    func saveNewCreditSimulation(name: String, project: Project, creditRepo: CreditRepository) {
        guard let realm = realm else {return}
        project.name = name
        simulation.name = name
        simulation.amountToFinance = creditRepo.creditData["Montant à financer"]
        simulation.duration = creditRepo.creditData["Durée"]
        simulation.rate = creditRepo.creditData["Taux"]
        simulation.insuranceRate = creditRepo.creditData["Taux assurance"]
        simulation.bookingFees = creditRepo.creditData["Frais de dossier"]
        simulation.mensuality = creditRepo.results[0]
        simulation.interestCost = creditRepo.results[1]
        simulation.insuranceCost = creditRepo.results[2]
        simulation.totalCost = creditRepo.results[3]
         realm.safeWrite {
            realm.add(simulation)
            realm.add(project)
        }
    }
    
    func addCreditSimulationToExistantProject(project: Project, creditRepo: CreditRepository) {
        guard let realm = realm else {return}
        simulation.name = project.name
        simulation.amountToFinance = creditRepo.creditData["Montant à financer"]
        simulation.duration = creditRepo.creditData["Durée"]
        simulation.rate = creditRepo.creditData["Taux"]
        simulation.insuranceRate = creditRepo.creditData["Taux assurance"]
        simulation.bookingFees = creditRepo.creditData["Frais de dossier"]
        simulation.mensuality = creditRepo.results[0]
        simulation.interestCost = creditRepo.results[1]
        simulation.insuranceCost = creditRepo.results[2]
        simulation.totalCost = creditRepo.results[3]
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
    
    func deleteCreditSimulation(creditToDelete: Results<CreditSimulation>) {
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.delete(creditToDelete)
        }
    }

}
