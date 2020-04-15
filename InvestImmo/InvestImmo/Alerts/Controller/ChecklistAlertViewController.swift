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
    var checklistRepo: ChecklistRepository?
    var rentaRepo: RentabilityRepository?
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
        let alertVC = newProjectAlert.alert(checklist: checklistRepo!, simulation: rentaRepo!)
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
    
    private func saveSimulation(project: Project, rentaRepo: RentabilityRepository) {
        mySimulation.name = project.name
        mySimulation.estatePrice = rentaRepo.rentabilityData["Prix du bien"]
        mySimulation.worksPrice = rentaRepo.rentabilityData["Coût des travaux"]
        mySimulation.notaryFees = rentaRepo.rentabilityData["Frais de notaire"]
        mySimulation.monthlyRent = rentaRepo.rentabilityData["Loyer mensuel"]
        mySimulation.propertyTax = rentaRepo.rentabilityData["Taxe foncière"]
        mySimulation.maintenanceFees = rentaRepo.rentabilityData["Frais d'entretien"]
        mySimulation.charges = rentaRepo.rentabilityData["Charges de copropriété"]
        mySimulation.managementFees = rentaRepo.rentabilityData["Frais de gérance"]
        mySimulation.insurance = rentaRepo.rentabilityData["Assurance loyers impayés"]
        mySimulation.creditCost = rentaRepo.rentabilityData["Coût du crédit"]
        mySimulation.grossYield = rentaRepo.rentabilityResultData["Rendement Brut"]
        mySimulation.netYield = rentaRepo.rentabilityResultData["Rendement Net"]
        mySimulation.annualCashflow = rentaRepo.rentabilityResultData["Cash-Flow Annuel"]
        mySimulation.mensualCashflow = rentaRepo.rentabilityResultData["Cash-Flow Mensuel"]
        try! self.realm.write {
            self.realm.add(mySimulation)
        }
    }
    
    private func saveChecklistGeneral(project: Project, checklist: ChecklistRepository) {
        checklistGeneral.name = project.name
        checklistGeneral.estateType = checklist.checklistData[0]["Type de bien"]
        checklistGeneral.visitDate = checklist.checklistData[0]["Date de la visite"]
        checklistGeneral.surfaceArea = checklist.checklistData[0]["Superficie"]
        try! self.realm.write {
            self.realm.add(checklistGeneral)
        }
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
        guard let rentaRepo = rentaRepo else {return}
        if isMySimulationDataNil(simulationCashflow: rentaRepo.rentabilityResultData["Cash-Flow Mensuel"]) {
            guard let checklist = checklistRepo else {return}
            if self.checkIfTheProjectAlreadyHaveSavedChecklist(project: project) {
                self.displayAlertForDuplicateProjectName()
            } else {
            saveChecklistGeneral(project: project, checklist: checklist)
                dismiss(animated: true)
            }
        } else {
            if checkIfTheProjectAlreadyHaveSavedSimulation(project: project) {
                self.displayAlertForDuplicateProjectName()
            } else {
                saveSimulation(project: project, rentaRepo: rentaRepo)
                dismiss(animated: true)
            }
        }
        
    }
}
