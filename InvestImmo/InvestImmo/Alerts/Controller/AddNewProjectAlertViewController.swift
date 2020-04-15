//
//  AddNewProjectAlertViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 05/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewProjectAlertViewController: UIViewController {

    
    //MARK: - Properties
    let realm = try! Realm()
    lazy var myProjects: Results<Project> = {
    self.realm.objects(Project.self)}()
    var checklistRepo: ChecklistRepository?
    var rentaRepo: RentabilityRepository?
    var myNewProject = Project()
    var mySimulation = RentabilitySimulation()
    var checklistGeneral = ChecklistGeneral()
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var projectNameLabel: UITextField!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    
    @IBAction func didTapOnNewProjectButton(_ sender: Any) {
        guard let projectName = projectNameLabel.text else {return}
        guard let rentaRepo = rentaRepo else {return}
        if self.isMySavedProjectsNil(projects: myProjects) {
            
            if isMySimulationDataNil(simulationCashflow: rentaRepo.rentabilityResultData["Cash-Flow Mensuel"]) {
                self.saveNewProjectData(name: projectName)
                self.saveChecklistGeneralData(name: projectName)
            } else {
                self.saveNewProjectData(name: projectName)
                self.saveSimulationData(name: projectName)
            }
        } else {
            if isMyProjectNameUnique(name: projectName, projects: self.myProjects) {
                if isMySimulationDataNil(simulationCashflow: rentaRepo.rentabilityResultData["Cash-Flow Mensuel"]) {
                    self.saveNewProjectData(name: projectName)
                    self.saveChecklistGeneralData(name: projectName)
                } else {
                    self.saveNewProjectData(name: projectName)
                    self.saveSimulationData(name: projectName)
                }
            } else {
                self.displayAlertForDuplicateProjectName()
            }
        }
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Methods
    
    private func saveNewProjectData(name: String) {
        myNewProject.name = name
        try! self.realm.write {
            self.realm.add(myNewProject)
        }
    }
    
    private func saveSimulationData(name: String) {
        guard let rentaRepo = rentaRepo else {return}
        mySimulation.name = name
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
    
    private func saveChecklistGeneralData(name: String) {
        guard  let checklist = checklistRepo else {return}
        checklistGeneral.name = name
        checklistGeneral.estateType = checklist.checklistData[0]["Type de bien"]
        checklistGeneral.visitDate = checklist.checklistData[0]["Date de la visite"]
        checklistGeneral.surfaceArea = checklist.checklistData[0]["Superficie"]
        try! self.realm.write {
            self.realm.add(checklistGeneral)
        }
    }
    
}
