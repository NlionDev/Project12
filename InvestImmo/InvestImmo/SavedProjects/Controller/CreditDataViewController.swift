//
//  CreditDataViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 20/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class CreditDataViewController: UIViewController {
    
    //MARK: - Properties
    private var results = [String]()
    private var titles = [String]()
    private var creditRepo = CreditRepository()
    private var simulation = CreditSimulation()
    private var realmRepo = RealmRepository()
    var selectedProject: Project?
    
    //MARK: - Outlets

    @IBOutlet weak var credtiTableView: UITableView!
    @IBOutlet weak var creditLabel: UILabel!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getResultsAndTitles()
        configurePage()
        credtiTableView.reloadData()
    }
    

//MARK: - Methods

    
    private func nibRegister() {
        let nibNameForDetailsSimulationCell = UINib(nibName: "DetailsSimulationTableViewCell", bundle: nil)
        credtiTableView.register(nibNameForDetailsSimulationCell, forCellReuseIdentifier: "DetailsSimulationCell")
    }
    
    private func getResultsAndTitles() {
        for (title, _) in creditRepo.creditData {
            titles.append(title)
        }
        for title in creditRepo.resultTitles {
            titles.append(title)
        }
        if let projectName = selectedProject?.name {
            simulation = realmRepo.getCreditSimulationWithProjectName(name: projectName)
            results = realmRepo.getSavedCreditSimulationResultsData(simulation: simulation)
        }
    }
    
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

extension CreditDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditRepo.allTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = credtiTableView.dequeueReusableCell(withIdentifier: "DetailsSimulationCell", for: indexPath) as? DetailsSimulationTableViewCell else {return UITableViewCell()}
        if results.count != 0 {
            let title = titles[indexPath.row]
            let result = results[indexPath.row]
            cell.configure(title: title, result: result)
        }
        return cell
    }
    
    
}

