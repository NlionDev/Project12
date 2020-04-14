//
//  DetailsSavedSimulationsViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 02/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class DetailsSavedSimulationsViewController: UIViewController {

    //MARK: - Properties
    
    var selectedSimulation: RentabilitySimulation?
    
    //MARK: - Outlets
    
    @IBOutlet weak var simulationDetailsScrollView: UIScrollView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var estatePriceLabel: UILabel!
    @IBOutlet weak var worksPriceLabel: UILabel!
    @IBOutlet weak var notaryFeesLabel: UILabel!
    @IBOutlet weak var monthlyRentLabel: UILabel!
    @IBOutlet weak var grossYieldLabel: UILabel!
    @IBOutlet weak var propertyTaxLabel: UILabel!
    @IBOutlet weak var maintenanceFeesLabel: UILabel!
    @IBOutlet weak var chargesLabel: UILabel!
    @IBOutlet weak var managementFeesLabel: UILabel!
    @IBOutlet weak var insuranceLabel: UILabel!
    @IBOutlet weak var creditCostLabel: UILabel!
    @IBOutlet weak var netYieldLabel: UILabel!
    @IBOutlet weak var annualCashflowLabel: UILabel!
    @IBOutlet weak var mensualCashflowLabel: UILabel!
    @IBOutlet weak var newSimulationButton: UIButton!
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSavedSimulationsNavigationBarStyle()
        showNoDataLabel()
    }
    
    //MARK: - Actions
    
    @IBAction func didTapOnNewSimulationButton(_ sender: Any) {
        performSegue(withIdentifier: "NewSimulationSegue", sender: self)
    }
    
    
    //MARK: - Methods
    
    private func showNoDataLabel() {
        if selectedSimulation?.mensualCashflow == nil {
            simulationDetailsScrollView.isHidden = true
            noDataLabel.isHighlighted = false
            newSimulationButton.isHidden = false
        } else {
            configurePage()
            simulationDetailsScrollView.isHidden = false
            noDataLabel.isHidden = true
            newSimulationButton.isHidden = true
        }
    }
    
    private func configurePage() {
        if let simulation = selectedSimulation {
            nameLabel.text = simulation.name
            guard let estatePrice = simulation.estatePrice else {return}
            estatePriceLabel.text = estatePrice + " €"
            guard let worksPrice = simulation.worksPrice else {return}
            worksPriceLabel.text = worksPrice + " €"
            guard let notaryFees = simulation.notaryFees else {return}
            notaryFeesLabel.text = notaryFees + " €"
            guard let monthlyRent = simulation.monthlyRent else {return}
            monthlyRentLabel.text = monthlyRent + " €"
            guard let grossYield = simulation.grossYield else {return}
            grossYieldLabel.text = grossYield
            guard let propertyTax = simulation.propertyTax else {return}
            propertyTaxLabel.text = propertyTax + " €"
            guard let maintenanceFees = simulation.maintenanceFees else {return}
            maintenanceFeesLabel.text = maintenanceFees + " €"
            guard let charges = simulation.charges else {return}
            chargesLabel.text = charges + " €"
            guard let managementFees = simulation.managementFees else {return}
            managementFeesLabel.text = managementFees + " %"
            guard let insurance = simulation.insurance else {return}
            insuranceLabel.text = insurance + " €"
            guard let creditCost = simulation.creditCost else {return}
            creditCostLabel.text = creditCost + " €"
            guard let netYield = simulation.netYield else {return}
            netYieldLabel.text = netYield
            guard let annualCashflow = simulation.annualCashflow else {return}
            annualCashflowLabel.text = annualCashflow
            guard let mensualCashflow = simulation.mensualCashflow else {return}
            mensualCashflowLabel.text = mensualCashflow
        }
    }
    

}
