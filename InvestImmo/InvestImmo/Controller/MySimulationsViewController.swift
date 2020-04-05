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
    lazy var myProjects: Results<Project> = {
        self.realm.objects(Project.self)}()
    lazy var mySavedSimulations: Results<RentabilitySimulation> = {
        self.realm.objects(RentabilitySimulation.self)}()
    lazy var checklistGeneral: Results<ChecklistGeneral> = {
        self.realm.objects(ChecklistGeneral.self)}()
    private var selectedProject: Project?
    private var selectedSimulation: RentabilitySimulation?
    private var selectedChecklistGeneral: ChecklistGeneral?
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var noProjectSavedLabel: UILabel!
    @IBOutlet weak var savedProjectsTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSavedSimulationsNavigationBarStyle()
        configureBackgroundImageForTableView(tableView: savedProjectsTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        savedProjectsTableView.reloadData()
        showNoDataLabel()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChoiceDetails" {
            guard let destination = segue.destination as? DetailsChoiceViewController,
                let selectedProject = selectedProject,
                let selectedProjectName = selectedProject.name else {return}
            destination.selectedChecklistGeneral = getChecklistGeneralWithProjectName(name: selectedProjectName)
            destination.selectedSimulation = getSimulationWithProjectName(name: selectedProjectName)
        }
    }
    
    //MARK: - Methods
    
    private func showNoDataLabel() {
        if myProjects.isEmpty {
            savedProjectsTableView.isHidden = true
            noProjectSavedLabel.isHidden = false
        } else {
            noProjectSavedLabel.isHidden = true
            savedProjectsTableView.isHidden = false
        }
    }
    
    private func getChecklistGeneralWithProjectName(name: String) -> ChecklistGeneral {
        var checklistToReturn = ChecklistGeneral()
        for checklist in checklistGeneral {
            if checklist.name == name {
                checklistToReturn = checklist
            }
        }
        return checklistToReturn
    }
    
    private func getSimulationWithProjectName(name: String) -> RentabilitySimulation {
        var simulationToReturn = RentabilitySimulation()
        for simulation in mySavedSimulations {
            if simulation.name == name {
                simulationToReturn = simulation
            }
        }
        return simulationToReturn
    }
    


}

//MARK: - Extensions

extension SavedSimulationsViewController: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? savedProjectsTableViewCell else {
            
            return UITableViewCell()
        }
        if let projectName = myProjects[indexPath.row].name {
            cell.configure(projectName: projectName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = myProjects[indexPath.row]
        performSegue(withIdentifier: "goToChoiceDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let selectedProjectName = myProjects[indexPath.row].name {
                let simulationToDelete = realm.objects(RentabilitySimulation.self).filter("name = '\(selectedProjectName)'")
                let checklistGeneralToDelete = realm.objects(ChecklistGeneral.self).filter("name = '\(selectedProjectName)'")
                let projectToDelete = realm.objects(Project.self).filter("name = '\(selectedProjectName)'")
                try! realm.write {
                    realm.delete(projectToDelete)
                    realm.delete(simulationToDelete)
                    realm.delete(checklistGeneralToDelete)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                showNoDataLabel()
            }
        }
    }
}


