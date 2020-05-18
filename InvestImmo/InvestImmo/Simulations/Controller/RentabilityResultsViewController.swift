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
    private let projectRepository = ProjectRepository()
    private let rentabilityExistantProjectPopUp = RentabilityExistantProjectPopUp()
    private let rentabilityNewProjectPopUp = RentabilityNewProjectPopUp()
    var rentabilityCalculator: RentabilityCalculator?
    var rentabilityRepository: RentabilityRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var rentabilityResultsTableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
    }
    
    //MARK: - Actions
    @IBAction private func didTapOnSaveButton(_ sender: Any) {
        guard let rentabilityRepository = rentabilityRepository else {return}
        let alert =  projectRepository.myProjects.isEmpty ? rentabilityNewProjectPopUp.alert(rentability: rentabilityRepository) : rentabilityExistantProjectPopUp.alert(rentability: rentabilityRepository)
        present(alert, animated: true)
    }
    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibName = UINib(nibName: SimulationsCells.result.name, bundle: nil)
        rentabilityResultsTableView.register(nibName, forCellReuseIdentifier: SimulationsCells.result.reuseIdentifier)
    }
    
}

//MARK: - Extension

extension RentabilityResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return resultCellRowInSection
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
