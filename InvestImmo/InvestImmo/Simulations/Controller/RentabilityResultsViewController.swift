//
//  RentabilityResultsViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// ViewController for present result of Credit Simulation
class RentabilityResultsViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Insrance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    /// Instance of RentabilityExistantprojectPopUp for present pop up and save  rentability simulation to an existant project
    private let rentabilityExistantProjectPopUp = RentabilityExistantProjectPopUp()
    
    /// Instance of RentabilityNewprojectPopUp for present pop up and save new rentability simulation
    private let rentabilityNewProjectPopUp = RentabilityNewProjectPopUp()
    
    /// Instance of RentabilityCalculator past from RentabilitySimulationViewController
    var rentabilityCalculator: RentabilityCalculator?
    
    /// Instance of RentabilityRepository past from RentabilitySimulationViewController
    var rentabilityRepository: RentabilityRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var rentabilityResultsTableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
    }
    
    //MARK: - Actions
    
    /// Action activated when tap on save button for save the rentability Simlulation
    @IBAction private func didTapOnSaveButton(_ sender: Any) {
        guard let rentabilityRepository = rentabilityRepository else {return}
        let alert =  projectRepository.myProjects.isEmpty ? rentabilityNewProjectPopUp.alert(rentability: rentabilityRepository) : rentabilityExistantProjectPopUp.alert(rentability: rentabilityRepository)
        present(alert, animated: true)
    }
    
    //MARK: - Methods
    
    /// Method for register rentability result cell
    private func nibRegister() {
        let nibName = UINib(nibName: SimulationsCells.result.name, bundle: nil)
        rentabilityResultsTableView.register(nibName, forCellReuseIdentifier: SimulationsCells.result.reuseIdentifier)
    }
    
}

//MARK: - Extension

/// Extension of RentabilityResultsViewController for TableView Delegate and DataSource
extension RentabilityResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfTitles = Int()
        if let rentabilityRepository = rentabilityRepository {
            numberOfTitles = rentabilityRepository.resultTitles.count
        }
        return numberOfTitles
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimulationsCells.result.reuseIdentifier, for: indexPath) as? ResultTableViewCell else {return UITableViewCell()}
        if let calculator = rentabilityCalculator,
            let rentabilityRepository = rentabilityRepository {
            cell.configureForRenta(title: rentabilityRepository.resultTitles[indexPath.row], result: rentabilityRepository.results[indexPath.row], isPositive: calculator.isResultPositive(result: rentabilityRepository.resultsForPositiveCheck[indexPath.row]))
        }
        return cell
    }
    
}
