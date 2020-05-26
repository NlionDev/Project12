//
//  CreditDataViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 20/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for CreditDataViewController
class CreditDataViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Array to store credit simulation results to display
    private var results = [String]()
    
    /// Array to store credit simulation titles to display
    private var titles = [String]()
    
    /// Instance of CreditRepository
    private var creditRepository = CreditRepository()
    
    /// Instance of CreditSimulation
    private var simulation = CreditSimulation()
    
    /// Property to store a selected Project past from SavedProjectsViewController
    var selectedProject: Project?
    
    //MARK: - Outlets
    @IBOutlet weak private var credtiTableView: UITableView!
    @IBOutlet weak private var creditLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getResultsAndTitles()
        configurePage()
        credtiTableView.reloadData()
    }
    
//MARK: - Methods
    
    /// Method for register nib cells
    private func nibRegister() {
        let nibNameForDetailsSimulationCell = UINib(nibName: SavedProjectsCell.simulation.name, bundle: nil)
        credtiTableView.register(nibNameForDetailsSimulationCell, forCellReuseIdentifier: SavedProjectsCell.simulation.reuseIdentifier)
    }
    
    /// Method for retrieve results and titles from saved Credit simulation with specific project name
    private func getResultsAndTitles() {
        titles = creditRepository.allTitles
        if let projectName = selectedProject?.name {
            simulation = creditRepository.getCreditSimulationWithProjectName(name: projectName)
            results = creditRepository.getSavedCreditSimulationResultsData(creditSimulation: simulation)
        }
    }
    
    /// Method for configure page and hide or show tableview and label
    private func configurePage() {
        if results.count == 0 {
            credtiTableView.isHidden = true
            creditLabel.isHidden = false
        } else {
            credtiTableView.isHidden = false
            creditLabel.isHidden = true
        }
    }
}

//MARK: - Extension

/// Extension of CreditDataViewController for tableview delegate and datasource
extension CreditDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditRepository.allTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = credtiTableView.dequeueReusableCell(withIdentifier: SavedProjectsCell.simulation.reuseIdentifier, for: indexPath) as? DetailsSimulationTableViewCell else {return UITableViewCell()}
        if results.count != 0 {
            let title = titles[indexPath.row]
            let result = results[indexPath.row]
            cell.configure(title: title, result: result)
        }
        return cell
    }
}

