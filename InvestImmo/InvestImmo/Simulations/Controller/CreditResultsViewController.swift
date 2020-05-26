//
//  CreditResultsViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// ViewController for present result of Credit Simulation
class CreditResultsViewController: UIViewController {

    
    //MARK: - Properties
    
    /// Instance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    /// Instance of CreditNewprojectPopUp for present pop up and save new Credit simulation
    private let creditNewProjectPopUp = CreditNewProjectPopUp()
    
    /// Instance of CreditExistantprojectPopUp for present pop up and save  Credit simulation to an existant project
    private let creditExistantProjectPopUp = CreditExistantProjectPopUp()
    
    /// Instance of CreditRepository past from CreditSimulationViewController
    var creditRepository: CreditRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var creditResultsTableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        creditResultsTableView.reloadData()
    }
    
    //MARK: - Actions
    
    /// Action activated when tap on save button for save the Credit Simlulation
    @IBAction private func didTapOnSaveButton(_ sender: Any) {
        guard let creditRepository = creditRepository else {return}
        let alert = projectRepository.myProjects.isEmpty ? creditNewProjectPopUp.alert(credit: creditRepository) : creditExistantProjectPopUp.alert(credit: creditRepository)
        present(alert, animated: true)
    }
    
    
    //MARK: - Methods
    
    /// Method for register credit result cell
    private func nibRegister() {
        let nibName = UINib(nibName: SimulationsCells.result.name, bundle: nil)
        creditResultsTableView.register(nibName, forCellReuseIdentifier: SimulationsCells.result.reuseIdentifier)
    }

}

//MARK: - Extension

/// Extension of CreditResultsViewController for TableView Delegate and DataSource
extension CreditResultsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfTitles = Int()
        if let creditRepository = creditRepository {
            numberOfTitles = creditRepository.resultTitles.count
        }
       return numberOfTitles
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimulationsCells.result.reuseIdentifier, for: indexPath) as? ResultTableViewCell else {return UITableViewCell()}
        if let creditRepository = creditRepository {
            cell.configureForCredit(title: creditRepository.resultTitles[indexPath.row], result: creditRepository.results[indexPath.row])
        }
        return cell
    }
    
}
