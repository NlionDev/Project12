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
    private let rentaRepo = RentabilityRepository()
    private let realmRepo = RealmRepository()
    private var simulation = RentabilitySimulation()
    var selectedProject: Project?
    
    //MARK: - Outlets
    
    @IBOutlet weak var rentabilityTableView: UITableView!
    @IBOutlet weak var rentabilityLabel: UILabel!
    
    
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
        let nibNameForDetailsSimulationCell = UINib(nibName: "DetailsSimulationTableViewCell", bundle: nil)
        rentabilityTableView.register(nibNameForDetailsSimulationCell, forCellReuseIdentifier: "DetailsSimulationCell")
    }

    private func getResultsAndTitles() {
        for (title, _) in rentaRepo.rentabilityData {
            titles.append(title)
        }
        for title in rentaRepo.resultTitles {
            titles.append(title)
        }
        if let projectName = selectedProject?.name {
            simulation = realmRepo.getRentabilitySimulationWithProjectName(name: projectName)
            results = realmRepo.getSavedRentabilitySimulationResultsData(simulation: simulation)
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
        return rentaRepo.allTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = rentabilityTableView.dequeueReusableCell(withIdentifier: "DetailsSimulationCell", for: indexPath) as? DetailsSimulationTableViewCell else {return UITableViewCell()}
        if results.count != 0 {
            let title = titles[indexPath.row]
            let result = results[indexPath.row]
            cell.configure(title: title, result: result)
        }
        return cell
    }
}

