//
//  MySimulationsViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 26/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class SavedSimulationsViewController: UIViewController {

    //MARK: - Properties
    
    let realm = try! Realm()
    lazy var mySavedSimulations: Results<RentabilitySimulation> = {
        self.realm.objects(RentabilitySimulation.self)}()
    lazy var checklistGeneral: Results<ChecklistGeneral> = {
        self.realm.objects(ChecklistGeneral.self)}()
    private var selectedSimulation: RentabilitySimulation?
    private var selectedChecklistGeneral: ChecklistGeneral?
    
    //MARK: - Outlets
    
    @IBOutlet weak var savedSimulationsTableView: UITableView!
    @IBOutlet weak var savedSimulationsLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSavedSimulationsNavigationBarStyle()
        configureBackgroundImageForTableView(tableView: savedSimulationsTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        savedSimulationsTableView.reloadData()
        showSavedSimulationsLabel()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChoiceDetails" {
            guard let destination = segue.destination as? DetailsChoiceViewController,
                let selectedSimulation = selectedSimulation else {return}
            for checklist in checklistGeneral {
                if checklist.name == selectedSimulation.name {
                    destination.selectedChecklistGeneral = checklist
                }
            }
            destination.selectedSimulation = selectedSimulation
        }
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

extension SavedSimulationsViewController: UITableViewDataSource, UITableViewDelegate {
    

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
        performSegue(withIdentifier: "goToChoiceDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let selectedSimulationName = mySavedSimulations[indexPath.row].name {
                let simulationToDelete = realm.objects(RentabilitySimulation.self).filter("name = '\(selectedSimulationName)'")
                let checklistGeneralToDelete = realm.objects(ChecklistGeneral.self).filter("name = '\(selectedSimulationName)'")
                try! realm.write {
                    realm.delete(simulationToDelete)
                    realm.delete(checklistGeneralToDelete)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                showSavedSimulationsLabel()
            }
        }
    }
}


