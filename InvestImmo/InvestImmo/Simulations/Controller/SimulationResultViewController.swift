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
    
    private let realmRepo = RealmRepository()
    private let rentaExistantProjectAlert = RentabilityExistantProjectAlert()
    private let rentaNewProjectAlert = RentabilityNewProjectAlert()
    private let creditNewProjectAlert = CreditNewProjectAlert()
    private let creditExistantProjectAlert = CreditExistantProjectAlert()
    var rentaRepo: RentabilityRepository?
    var creditRepo: CreditRepository?
    var rentaCalculator: RentabilityCalculator?
    var creditCalculator: CreditCalculator?
    
    //MARK: - Outlets
    
    @IBOutlet weak var resultTableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
    }
    
    //MARK: - Actions
    
    @IBAction func didTapOnSaveButton(_ sender: UIButton) {
        guard let rentaRepo = rentaRepo else {return}
        guard let creditRepo = creditRepo else {return}
        if isMyRentabilityDataNil(numberToTest: rentaRepo.results.count) {
            
            let alert = realmRepo.myProjects.isEmpty ? creditNewProjectAlert.alert(credit: creditRepo) : creditExistantProjectAlert.alert(credit: creditRepo)
            present(alert, animated: true)
        } else {
            
            let alert =  realmRepo.myProjects.isEmpty ? rentaNewProjectAlert.alert(rentability: rentaRepo) : rentaExistantProjectAlert.alert(rentability: rentaRepo)
            present(alert, animated: true)
        }
    }
    
    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibName = UINib(nibName: "ResultTableViewCell", bundle: nil)
        resultTableView.register(nibName, forCellReuseIdentifier: "ResultCell")
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
                if let creditRepo = creditRepo {
                    cell.configureForCredit(title: creditRepo.resultTitles[indexPath.row], result: creditRepo.results[indexPath.row])
                }
            } else {
                if let rentaRepo = rentaRepo {
                    cell.configureForRenta(title: rentaRepo.resultTitles[indexPath.row], result: rentaRepo.results[indexPath.row], isPositive: calculator.isResultPositive(result: rentaRepo.resultsForPositiveCheck[indexPath.row]))
                }
            }
        }
        return cell
    }
    

}
