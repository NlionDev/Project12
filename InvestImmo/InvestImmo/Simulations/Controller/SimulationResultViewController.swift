//
//  SimulationResultViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class SimulationResultViewController: UIViewController {

    //MARK: - Properties
    
    private let rentaRepo = RentabilityRepository()
    private let creditRepo = CreditRepository()
    var rentaCalculator: RentabilityCalculator?
    var creditCalculator: CreditCalculator?
    
    //MARK: - Outlets
    
    @IBOutlet weak var resultTableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRentabilityResults()
        getCreditResults()
        nibRegister()
        
    }
    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibName = UINib(nibName: "ResultTableViewCell", bundle: nil)
        resultTableView.register(nibName, forCellReuseIdentifier: "ResultCell")
    }
    
    private func getRentabilityResults() {
        if let calculator = rentaCalculator {
            rentaRepo.results.append(calculator.getGrossYield() + " %")
            rentaRepo.resultsForPositiveCheck.append(calculator.getGrossYield())
            rentaRepo.results.append(calculator.getNetYield() + " %")
            rentaRepo.resultsForPositiveCheck.append(calculator.getNetYield())
            rentaRepo.results.append(calculator.getAnnualCashflow() + " €")
            rentaRepo.resultsForPositiveCheck.append(calculator.getAnnualCashflow())
            rentaRepo.results.append(calculator.getMensualCashflow() + " €")
            rentaRepo.resultsForPositiveCheck.append(calculator.getMensualCashflow())
        }
    }
    
    private func getCreditResults() {
        if let calculator = creditCalculator {
            creditRepo.results.append(calculator.getStringMensuality() + " €")
            creditRepo.results.append(calculator.getStringInterestCost() + " €")
            creditRepo.results.append(calculator.getStringInsuranceCost() + " €")
            creditRepo.results.append(calculator.getTotalCost() + " €")
        }
    }

}

//MARK: - Extension

extension SimulationResultViewController: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell else {
            return UITableViewCell()}
        if let calculator = rentaCalculator {
            if calculator.rentabilityData["Prix du bien"] == "" {
                cell.configureForCredit(title: creditRepo.resultTitles[indexPath.row], result: creditRepo.results[indexPath.row])
            } else {
                cell.configureForRenta(title: rentaRepo.resultTitles[indexPath.row], result: rentaRepo.results[indexPath.row], isPositive: calculator.isResultPositive(result: rentaRepo.resultsForPositiveCheck[indexPath.row]))
            }
        }
        return cell
    }
    

}
