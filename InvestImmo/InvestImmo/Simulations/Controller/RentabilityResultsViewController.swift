//
//  RentabilityResultsViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class RentabilityResultsViewController: UIViewController {

    
    
    //MARK: - Properties
    private let realmRepo = RealmRepository()
    private let rentaExistantProjectAlert = RentabilityExistantProjectAlert()
    private let rentaNewProjectAlert = RentabilityNewProjectAlert()
    var rentaCalculator: RentabilityCalculator?
    var rentaRepo: RentabilityRepository?
    
    //MARK: - Outlets
    @IBOutlet weak var rentabilityResultsTableView: UITableView!
    
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
    }
    

    //MARK: - Actions
    @IBAction func didTapOnSaveButton(_ sender: Any) {
        guard let rentaRepo = rentaRepo else {return}
        let alert =  realmRepo.myProjects.isEmpty ? rentaNewProjectAlert.alert(rentability: rentaRepo) : rentaExistantProjectAlert.alert(rentability: rentaRepo)
        present(alert, animated: true)
    }
    
    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibName = UINib(nibName: "ResultTableViewCell", bundle: nil)
        rentabilityResultsTableView.register(nibName, forCellReuseIdentifier: "ResultCell")
    }
    

}

//MARK: - Extension

extension RentabilityResultsViewController: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell else {return UITableViewCell()}
        if let calculator = rentaCalculator {
            if let rentaRepo = rentaRepo {
                cell.configureForRenta(title: rentaRepo.resultTitles[indexPath.row], result: rentaRepo.results[indexPath.row], isPositive: calculator.isResultPositive(result: rentaRepo.resultsForPositiveCheck[indexPath.row]))
            }
        }
        return cell
    }
    
}
