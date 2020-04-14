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
    var checklistData: ChecklistRepository?
    var mySimulationData: RentabilitySimulation?
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
        if self.isMySavedProjectsNil(projects: myProjects) {
            
            if isMySimulationDataNil(simulationCashflow: mySimulationData!.mensualCashflow) {
                self.saveNewProjectData(name: projectName)
                self.saveChecklistGeneralData(name: projectName)
            } else {
                self.saveNewProjectData(name: projectName)
                self.saveSimulationData(name: projectName)
            }
        } else {
            if isMyProjectNameUnique(name: projectName, projects: self.myProjects) {
                if isMySimulationDataNil(simulationCashflow: mySimulationData!.mensualCashflow) {
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
        guard let mySimulationData = mySimulationData else {return}
        mySimulation.name = name
        mySimulation.estatePrice = mySimulationData.estatePrice
        mySimulation.worksPrice = mySimulationData.worksPrice
        mySimulation.notaryFees = mySimulationData.notaryFees
        mySimulation.monthlyRent = mySimulationData.monthlyRent
        mySimulation.propertyTax = mySimulationData.propertyTax
        mySimulation.maintenanceFees = mySimulationData.maintenanceFees
        mySimulation.charges = mySimulationData.charges
        mySimulation.managementFees = mySimulationData.managementFees
        mySimulation.insurance = mySimulationData.insurance
        mySimulation.creditCost = mySimulationData.creditCost
        mySimulation.grossYield = mySimulationData.grossYield
        mySimulation.netYield = mySimulationData.netYield
        mySimulation.annualCashflow = mySimulationData.annualCashflow
        mySimulation.mensualCashflow = mySimulationData.mensualCashflow
        try! self.realm.write {
            self.realm.add(mySimulation)
        }
        
    }
    
    private func saveChecklistGeneralData(name: String) {
//        guard  let checklistData = checklistData else {return}
//        checklistGeneral.name = name
//        checklistGeneral.estateType = checklistData.estateType
//        checklistGeneral.visitDate = checklistData.visitDate
//        checklistGeneral.surfaceArea = checklistData.surfaceArea
//        try! self.realm.write {
//            self.realm.add(checklistGeneral)
//        }
    }
    
}
