//
//  ResultRentabilityViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 21/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class ResultRentabilityViewController: UIViewController {
    
    //MARK: - Properties
    
    var calculator: RentabilityCalculator?
    lazy var myProjects: Results<Project> = {
        self.realm.objects(Project.self)}()
    lazy var mySavedSimulations: Results<RentabilitySimulation> = {
        self.realm.objects(RentabilitySimulation.self)}()
    let realm = try! Realm()
    var myRentabilitySimulation = RentabilitySimulation()
    var myNewProject = Project()
    var existantProjectAlertService = ExistantProjectAlertService()
    var newProjectAlertService = NewProjectAlertService()
    var checklistData = ChecklistData()
    
    //MARK: - Outlets
    
    @IBOutlet weak private var grossYieldLabel: UILabel!
    @IBOutlet weak private var netYieldLabel: UILabel!
    @IBOutlet weak private var annualCashflowLabel: UILabel!
    @IBOutlet weak private var mensualCashflowLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSaveButtonItem(action: #selector(didTapOnSaveButton))
        displayResult()
        setupLabelTextColor()
    }
    
    //MARK: - Actions
    
    @objc func didTapOnSaveButton() {
        saveData()
        if myProjects.isEmpty {
            if #available(iOS 13.0, *) {
                let alertVC = newProjectAlertService.alert(checklist: checklistData, simulation: myRentabilitySimulation)
                present(alertVC, animated: true)
            } else {
            }
        } else {
            if #available(iOS 13.0, *) {
                let alertVC = existantProjectAlertService.alert(checklist: checklistData, simulation: myRentabilitySimulation)
                present(alertVC, animated: true)
            } else {
            }
        }
    }
    
    //MARK: - Methods
    
    private func displayResult() {
        if let calculator = calculator {
            grossYieldLabel.text = calculator.getGrossYield() + " %"
            netYieldLabel.text = calculator.getNetYield() + " %"
            annualCashflowLabel.text = calculator.getAnnualCashflow() + " €"
            mensualCashflowLabel.text = calculator.getMensualCashflow() + " €"
        }
    }
    
    private func adjustTextColor(result: String, label: UILabel) {
        var boolResult = true
        if let calculator = calculator {
            boolResult = calculator.isResultPositive(result: result)
        }
        if boolResult == true {
            label.textColor = UIColor(red: 33/255.0, green: 227/255.0, blue: 40/255.0, alpha: 1.0)
        } else {
            label.textColor = UIColor(red: 227/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
        }
    }
    
    private func setupLabelTextColor() {
        if let calculator = calculator {
            adjustTextColor(result: calculator.getGrossYield(), label: grossYieldLabel)
            adjustTextColor(result: calculator.getNetYield(), label: netYieldLabel)
            adjustTextColor(result: calculator.getAnnualCashflow(), label: annualCashflowLabel)
            adjustTextColor(result: calculator.getMensualCashflow(), label: mensualCashflowLabel)
        }
    }
    
    private func saveData() {
        guard let calculator = self.calculator else {return}
        self.myRentabilitySimulation.estatePrice = calculator.estatePrice
        self.myRentabilitySimulation.worksPrice = calculator.worksPrice
        self.myRentabilitySimulation.notaryFees = calculator.notaryFees
        self.myRentabilitySimulation.monthlyRent = calculator.monthlyRent
        self.myRentabilitySimulation.propertyTax = calculator.propertyTax
        self.myRentabilitySimulation.maintenanceFees = calculator.maintenanceFees
        self.myRentabilitySimulation.charges = calculator.charges
        self.myRentabilitySimulation.managementFees = calculator.managementFees
        self.myRentabilitySimulation.insurance = calculator.insurance
        self.myRentabilitySimulation.creditCost = calculator.creditCost
        self.myRentabilitySimulation.grossYield = grossYieldLabel.text
        self.myRentabilitySimulation.netYield = netYieldLabel.text
        self.myRentabilitySimulation.annualCashflow = annualCashflowLabel.text
        self.myRentabilitySimulation.mensualCashflow = mensualCashflowLabel.text
    }
    

    
}

