//
//  RentabilityDataViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 20/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class RentabilityDataViewController: UIViewController {

    
    //MARK: - Properties
    private var results = [String]()
    private var titles = [String]()
    private let rentabilityRepository = RentabilityRepository()
    private var simulation = RentabilitySimulation()
    var selectedProject: Project?
    
    //MARK: - Outlets
    @IBOutlet weak private var rentabilityTableView: UITableView!
    @IBOutlet weak private var rentabilityLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getResultsAndTitles()
        configurePage()
        rentabilityTableView.reloadData()
    }

    //MARK: - Methods
    private func nibRegister() {
        let nibNameForDetailsSimulationCell = UINib(nibName: SavedProjectsCell.simulation.name, bundle: nil)
        rentabilityTableView.register(nibNameForDetailsSimulationCell, forCellReuseIdentifier: SavedProjectsCell.simulation.reuseIdentifier)
    }

    private func getResultsAndTitles() {
        titles = rentabilityRepository.allTitles
        if let projectName = selectedProject?.name {
            simulation = rentabilityRepository.getRentabilitySimulationWithProjectName(name: projectName)
            results = rentabilityRepository.getSavedRentabilitySimulationResultsData(simulation: simulation)
        }
    }
    
    private func configurePage() {
        if results.count == 0 {
            rentabilityTableView.isHidden = true
            rentabilityLabel.isHidden = false
        } else {
            rentabilityTableView.isHidden = false
            rentabilityLabel.isHidden = true
        }
    }
}


//MARK: - Extension
extension RentabilityDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentabilityRepository.allTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = rentabilityTableView.dequeueReusableCell(withIdentifier: SavedProjectsCell.simulation.reuseIdentifier, for: indexPath) as? DetailsSimulationTableViewCell else {return UITableViewCell()}
        if results.count != 0 {
            let title = titles[indexPath.row]
            let result = results[indexPath.row]
            cell.configure(title: title, result: result)
        }
        return cell
    }
}

