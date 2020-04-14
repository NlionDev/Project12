//
//  ChecklistAlertViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 04/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class ChecklistAlertViewController: UIViewController {

    
    //MARK: - Properties
    
    let realm = try! Realm()
    lazy var myProjects: Results<Project> = {
        self.realm.objects(Project.self)}()
    private var selectedProject: Project?
    private var mySimulation = RentabilitySimulation()
    private var checklistGeneral = ChecklistGeneral()
    var checklistData: ChecklistRepository?
    var mySimulationData: RentabilitySimulation?
    let newProjectAlert = NewProjectAlert()
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var alertTableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTableView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func didTapOnCreateNewProject(_ sender: Any) {
        let alertVC = newProjectAlert.alert(checklist: checklistData!, simulation: mySimulationData!)
        present(alertVC, animated: true)
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Methods
    
    private func checkIfTheProjectAlreadyHaveSavedSimulation(project: Project) -> Bool {
        var result = true
        if let projectName = project.name {
            let simulations = realm.objects(RentabilitySimulation.self).filter("name = '\(projectName)'")
            if simulations.isEmpty {
                result = false
            } else {
                result = true
            }
        }
        return result
    }

    private func checkIfTheProjectAlreadyHaveSavedChecklist(project: Project) -> Bool {
        var result = true
        if let projectName = project.name {
            
            let checklists = realm.objects(ChecklistGeneral.self).filter("name = '\(projectName)'")
            if checklists.isEmpty {
                
                result = false
            } else {
                
                result = true
            }
        }
        return result
    }
    
    private func saveSimulation(project: Project, simulation: RentabilitySimulation) {
        mySimulation.name = project.name
        mySimulation.estatePrice = simulation.estatePrice
        mySimulation.worksPrice = simulation.worksPrice
        mySimulation.notaryFees = simulation.notaryFees
        mySimulation.monthlyRent = simulation.monthlyRent
        mySimulation.propertyTax = simulation.propertyTax
        mySimulation.maintenanceFees = simulation.maintenanceFees
        mySimulation.charges = simulation.charges
        mySimulation.managementFees = simulation.managementFees
        mySimulation.insurance = simulation.insurance
        mySimulation.creditCost = simulation.creditCost
        mySimulation.grossYield = simulation.grossYield
        mySimulation.netYield = simulation.netYield
        mySimulation.annualCashflow = simulation.annualCashflow
        mySimulation.mensualCashflow = simulation.mensualCashflow
        try! self.realm.write {
            self.realm.add(mySimulation)
        }
    }
    
    private func saveChecklistGeneral(project: Project, checklist: ChecklistRepository) {
//        checklistGeneral.name = project.name
//        checklistGeneral.estateType = checklist.estateType
//        checklistGeneral.visitDate = checklist.visitDate
//        checklistGeneral.surfaceArea = checklist.surfaceArea
//        try! self.realm.write {
//            self.realm.add(checklistGeneral)
//        }
    }

}

//MARK: - Extensions

extension ChecklistAlertViewController: UITableViewDataSource, UITableViewDelegate {


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return myProjects.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistAlertCell", for: indexPath) as? ChecklistAlertTableViewCell else {
        
        return UITableViewCell()
    }
    if let projectName = myProjects[indexPath.row].name {
        cell.configure(projectName: projectName)
    }
    return cell
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = myProjects[indexPath.row]
        guard let project = selectedProject else {return}
        if isMySimulationDataNil(simulationCashflow: mySimulationData?.mensualCashflow) {
            guard let checklistData = checklistData else {return}
            if self.checkIfTheProjectAlreadyHaveSavedChecklist(project: project) {
                self.displayAlertForDuplicateProjectName()
            } else {
            saveChecklistGeneral(project: project, checklist: checklistData)
                dismiss(animated: true)
            }
        } else {
            guard let mySimulationData = mySimulationData else {return}
            if checkIfTheProjectAlreadyHaveSavedSimulation(project: project) {
                self.displayAlertForDuplicateProjectName()
            } else {
                saveSimulation(project: project, simulation: mySimulationData)
                dismiss(animated: true)
            }
        }
        
    }
}
