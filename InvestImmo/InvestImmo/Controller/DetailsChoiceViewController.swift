//
//  DetailsChoiceViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 03/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class DetailsChoiceViewController: UIViewController {

    //MARK: - Properties
    
    var selectedSimulation: RentabilitySimulation?
    var selectedChecklistGeneral: ChecklistGeneral?
    
    //MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedSimulation = selectedSimulation {
            nameLabel.text = selectedSimulation.name
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rentabilityDetails" {
            guard let destination = segue.destination as? DetailsSavedSimulationsViewController,
                let selectedSimulation = selectedSimulation else {return}
            destination.selectedSimulation = selectedSimulation
        } else if segue.identifier == "checklistDetails" {
            guard let destination = segue.destination as? SavedChecklistsDetailsViewController,
                let selectedChecklistGeneral = selectedChecklistGeneral else {return}
            destination.checklistGeneral = selectedChecklistGeneral
        }
        
    }
    
    //MARK: - Actions
    
    @IBAction func didTapRentabilityButton(_ sender: Any) {
        performSegue(withIdentifier: "rentabilityDetails", sender: self)
    }
    
    @IBAction func didTapChecklistButton(_ sender: Any) {
        performSegue(withIdentifier: "checklistDetails", sender: self)
    }
    

}
