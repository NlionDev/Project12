//
//  MySimulationsViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 26/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class MySimulationsViewController: UIViewController {

    //MARK: - Properties
    
    let realm = try! Realm()
    var mySavedSimulations: [RentabilitySimulation] = []
    private var selectedSimulation: RentabilitySimulation?
    
    //MARK: - Outlets
    
    @IBOutlet weak var savedSimulationsTableView: UITableView!
    @IBOutlet weak var savedSimulationsLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        savedSimulationsTableView.reloadData()
        showSavedSimulationsLabel()
    }
    
    //MARK: - Methods
    
    private func showSavedSimulationsLabel() {
        if mySavedSimulations.isEmpty {
            savedSimulationsTableView.isHidden = true
            savedSimulationsLabel.isHidden = false
        } else {
            savedSimulationsLabel.isHidden = true
            savedSimulationsTableView.isHidden = false
        }
    }

}

//MARK: - Extensions

extension MySimulationsViewController: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySavedSimulations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimulationCell", for: indexPath) as? SavedSimulationTableViewCell else {
            
            return UITableViewCell()
        }
        
        if let simulationName = mySavedSimulations[indexPath.row].name,
            let simulationPrice = mySavedSimulations[indexPath.row].estatePrice {
            cell.configure(projectName: simulationName, projectPrice: simulationPrice)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSimulation = mySavedSimulations[indexPath.row]
        performSegue(withIdentifier: "DetailsSegueFromResults", sender: self)
    }
}

