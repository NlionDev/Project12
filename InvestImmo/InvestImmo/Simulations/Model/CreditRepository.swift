//
//  CreditRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class CreditRepository {
    
    //MARK: - Properties
    
    let cells: CreditCells = [CreditItem.amountToFinance, CreditItem.duration, CreditItem.rate, CreditItem.insuranceRate, CreditItem.bookingFees]
    var creditTextFieldCells = [TextFieldWithoutSubtitleTableViewCell]()
    var creditStepperCells = [StepperTableViewCell]()
    let creditDuration = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    let resultTitles = ["Mensualités", "Coût intérêts", "Coût assurance", "Coût total"]
    var results = [String]()
    var creditData = ["Montant à financer": "", "Durée": "", "Taux": "", "Taux assurance": "", "Frais de dossier": ""]
    var allTitles = ["Montant à financer", "Durée", "Taux", "Taux assurance", "Frais de dossier", "Mensualités", "Coût intérêts", "Coût assurance", "Coût total"]
    
    //MARK: - Methods
    
    func saveNewCreditSimulation(name: String, simulation: CreditSimulation, project: Project, realmRepo: RealmRepository, creditRepo: CreditRepository) {
        
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
        try! realmRepo.realm.write {
            realmRepo.realm.add(simulation)
            realmRepo.realm.add(project)
        }
    }
    
    func addCreditSimulationToExistantProject(project: Project, simulation: CreditSimulation, realmRepo: RealmRepository, creditRepo: CreditRepository) {
        simulation.name = project.name
        simulation.amountToFinance = creditRepo.creditData["Montant à financer"]
        simulation.duration = creditRepo.creditData["Durée"]
        simulation.rate = creditRepo.creditData["Taux"]
        simulation.insuranceRate = creditRepo.creditData["Taux assruance"]
        simulation.bookingFees = creditRepo.creditData["Frais de dossier"]
        simulation.mensuality = creditRepo.results[0]
        simulation.interestCost = creditRepo.results[1]
        simulation.insuranceCost = creditRepo.results[2]
        simulation.totalCost = creditRepo.results[3]
        try! realmRepo.realm.write {
            realmRepo.realm.add(simulation)
        }
    }


}
